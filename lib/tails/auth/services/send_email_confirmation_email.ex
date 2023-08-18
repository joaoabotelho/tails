defmodule Tails.Auth.Services.SendEmailConfirmationEmail do
  @moduledoc """
  Sends email with a link for the user to verify its new email address.
  """

  alias Tails.Users.User
  alias Tails.Mailer
  alias Tails.Mailer.EmailConfirmationEmail

  @spec call(User.t()) :: :ok | {:error, String.t()}
  def call(auth_record) do
    Task.Supervisor.async(Tails.AsyncEmailSupervisor, fn ->
      auth_record
      |> EmailConfirmationEmail.build()
      |> Mailer.deliver()
    end)
  end
end
