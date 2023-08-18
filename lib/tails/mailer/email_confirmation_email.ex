defmodule Tails.Mailer.EmailConfirmationEmail do
  @moduledoc false

  use Phoenix.Swoosh, layout: {TailsWeb.EmailView, :layout}, view: TailsWeb.EmailView

  import Tails.Mailer.MailerConfig

  def build(%{
        unconfirmed_email: unconfirmed_email,
        email_confirmation_token: email_confirmation_token
      })
      when not is_nil(unconfirmed_email) and not is_nil(email_confirmation_token) do
    new()
    |> to(unconfirmed_email)
    |> from({"Tails", from_mail()})
    |> subject("Confirm your email address")
    |> render_body(:email_confirmation,
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
    new()
    |> to(email)
    |> from({"Tails", from_mail()})
    |> subject("Confirm your email address")
    |> render_body(:email_confirmation,
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
