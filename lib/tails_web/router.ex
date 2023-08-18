defmodule TailsWeb.Router do
  use TailsWeb, :router
  use Pow.Phoenix.Router

  pipeline :api do
    plug(:accepts, ["json", "xlsx", "csv", "xml", "csp-report", "zip"])
    plug TailsWeb.APIAuthPlug, otp_app: :tails
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: TailsWeb.APIAuthErrorHandler
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:browser]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/", TailsWeb do
    pipe_through :api

    get "/", PageController, :index
  end

  scope "/app", TailsWeb do
    get "/", WebappController, :index
    get "/*path", WebappController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", TailsWeb.API.V1, as: :api_v1 do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    # resources "/session", SessionController, singleton: true, only: [:create, :delete]

    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    get "/session/renew", SessionController, :renew

    get "/auth/:provider/new", AuthorizationController, :new
    post "/auth/:provider/callback", AuthorizationController, :callback
  end

  scope "/api/v1", TailsWeb.API.V1, as: :api_v1 do
    pipe_through [:api, :api_protected]

    # protected API endpoints here
    get "/user", UserController, :show
    post "/user/complete-profile", UserController, :complete_profile
    patch "/user", UserController, :update
    get "/pets", PetController, :index
    get "/pets/:slug", PetController, :show
  end

  if Mix.env() == :dev do
    pipeline :browser do
      plug :accepts, ["html"]
      plug :fetch_session
      plug :put_root_layout, {TailsWeb.LayoutView, :root}
      plug :protect_from_forgery

      plug :put_secure_browser_headers, %{
        "Content-Security-Policy" =>
          "default-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline' cdnjs.cloudflare.com; style-src 'self' 'unsafe-inline' cdnjs.cloudflare.com; img-src 'self' data: employ-production-assets.s3.amazonaws.com"
      }
    end
  end
end
