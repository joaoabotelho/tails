defmodule Tails.Mailer.EmailConfirmationEmail do
  @moduledoc false

  import Tails.Mailer.MailerConfig

  import SendGrid.Email

  def build(%{
        unconfirmed_email: unconfirmed_email,
        email_confirmation_token: email_confirmation_token
      })
      when not is_nil(unconfirmed_email) and not is_nil(email_confirmation_token) do
    build()
    |> add_to(unconfirmed_email)
    |> put_from({"Tails", from_mail()})
    |> put_subject("Confirm your email address")
    |> put_phoenix_template(:email_confirmation,
      unconfirmed_email: unconfirmed_email,
      confirmation_url: build_confirmation_url(email_confirmation_token)
    )
  end

  def build(%{
        email: email,
        unconfirmed_email: unconfirmed_email,
        email_confirmation_token: email_confirmation_token
      })
      when not is_nil(email) and is_nil(unconfirmed_email) and
             not is_nil(email_confirmation_token) do
    build()
    |> add_to(email)
    |> put_from({"Tails", from_mail()})
    |> put_subject("Confirm your email address")
    |> put_phoenix_template(:email_confirmation,
      unconfirmed_email: email,
      confirmation_url: build_confirmation_url(email_confirmation_token)
    )
  end

  def preview do
    build(%{
      unconfirmed_email: "saurons-new-email@remote.com",
      email_confirmation_token: "TOKEN"
    })
  end

  def preview_details do
    [
      title: "Email Confirmation",
      description: "Email sent to users to confirm their new email address.",
      tags: [recipient: "all"]
    ]
  end

  defp build_confirmation_url(email_confirmation_token),
    do:
      Application.get_env(:tails, :client_link, "") <>
        "/confirm-email-change?token=#{email_confirmation_token}"
end
