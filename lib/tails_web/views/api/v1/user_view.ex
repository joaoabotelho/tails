defmodule TailsWeb.API.V1.UserView do
  use TailsWeb, :view

  alias Tails.Value.Response

  def render("show.json", %{user: user}) do
    %{
      name: user.name,
      slug: user.slug,
      role: user.role,
      status: user.status,
      email: user.email
    }
  end

  def render("success.json", _) do
    Response.init(%{status: :ok})
  end
end
