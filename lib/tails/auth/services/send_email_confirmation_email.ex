defmodule Tails.Auth.Services.SendEmailConfirmationEmail do
  @moduledoc """
  Sends email with a link for the user to verify its new email address.
  """

  require Logger

  alias Tails.Users.User
  alias Tails.Mailer.EmailConfirmationEmail
  alias SendGrid.Mail

  @spec call(User.t()) :: :ok | {:error, String.t()}
  def call(auth_record) do
    Logger.info("Starting SendEmailConfirmationEmail task...")

    task =
      Task.Supervisor.async(Tails.AsyncEmailSupervisor, fn ->
        auth_record
        |> EmailConfirmationEmail.build()
        |> Mail.send()
      end)

    result = Task.await(task)

    Logger.info("SendEmailConfirmationEmail task result: #{inspect(result)}")
  end
end
