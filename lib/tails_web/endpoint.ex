defmodule TailsWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :tails

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_tails_key",
    signing_salt: "cX3tuTaI"
  ]

  # Profile pictures are not downloadable like the other tiger files because these are public images and Tiger needs
  # to serve them directly on :dev environments
  if Mix.env() == :dev do
    plug Plug.Static, at: "/profile_pictures", from: "./media/profile_pictures"
  end

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.Static,
    at: "/",
    from: :tails,
    gzip: false,
    only: ~w(assets fonts images webapp favicon.ico robots.txt)

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Tails.Plugs.Parsers,
    parsers: [:multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library(),
    length: 20_000_000

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug Pow.Plug.Session, otp_app: :tails

  plug(CORSPlug, origin: &Tails.CORS.allowed_origin/1, headers: Tails.CORS.allowed_headers())

  plug TailsWeb.Router
end
