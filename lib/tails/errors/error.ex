defmodule Tails.Errors.Error do
  @moduledoc """
  Error behaviour to be used across Tails's codebase.

  This module allows you to create generic errors with custom fields that can
  later be used to report errors to Sentry.

  ## Usage

  You can build a simple error module just by calling `use Tails.Errors.Error`:

  ```elixir
  defmodule Tails.Errors.SlackError do
    use Tails.Errors.Error
  end
  ```

  Which you can then use to report errors with:

  ```elixir
  %Tails.Errors.Error{message: "Failed to post message on Slack"}
  |> Tails.Errors.send_error()
  ```

  Notice the `:message` field is automatically added for you whenever you call
  `use Tails.Errors.Error`.

  ## Default Message

  All modules that use this module will automatically have a `:message` field,
  however, any time you build an error that will be set to `nil`. If you want
  to have a default error message you can do so through the `:message` option :

  ```elixir
  defmodule Tails.Errors.SlackError do
    use Tails.Errors.Error, message: "Error posting message to Slack."
  end
  ```

  ## Custom Fields

  By default, any module that calls `use Tails.Errors.Error` will be converted
  to an exception (defexception) with a `:message` field.  However, sometimes,
  just a simple message might not be enough in order to understand the full
  scope of the error. In those situations you can use the `:custom_fields`
  option to specify other fields you'd like to support on your error:

  ```elixir
  defmodule Tails.Errors.SignUpError do
    use Tails.Errors.Error, custom_fields: [:user, :email]
  end
  ```

  By default, the call to `Tails.Errors.Error.send_error/1` will send all the
  `custom_fields` to Sentry. Sometimes this might not be the intended
  purpose, especially if there's PII data involved, as such, you can override
  the `custom_data/1` function to just report some of the fields

  ```elixir
  defmodule Tails.Errors.SignUpError do
    use Tails.Errors.Error, custom_fields: [:user, :email]

    # Report the only the user's slug instead of the whole user information.
    @impl true
    def custom_data(%{user: nil, email: email}), do: %{user_slug: nil, email_module: email}
    def custom_data(%{user: user, email: email}), do: %{user_slug: user.slug, email_module: email}
  end
  ```
  """

  defmacro __using__(opts) do
    custom_fields = Keyword.get(opts, :custom_fields, [])
    message = [{:message, Keyword.get(opts, :message)}]

    quote do
      @behaviour Tails.Errors.Error

      defexception unquote(custom_fields) ++ unquote(message)

      # By default, the `custom_data/1` function will return a map with all the
      # keys present in the `custom_fields` option.
      def custom_data(error) do
        error
        |> Map.from_struct()
        |> Enum.filter(fn {key, _value} -> key in unquote(custom_fields) end)
        |> Enum.into(%{})
      end

      defoverridable Tails.Errors.Error
    end
  end

  @callback custom_data(error :: struct()) :: map()

  @doc """
  Returns list of custom information that should be reported for this error in
  whatever error reporting application Tails uses.

  ## Examples

      iex> user = %User{slug: "user_slug"}
      iex> error = %Tails.Errors.MailerError{user: user, email: Tails.Mailer.WelcomeEmail, message: "Hey!"}
      iex> Tails.Errors.Error.metadata(error)
      %{user: "user_slug", email: Tails.Mailer.WelcomeCompanyEmail}
  """
  @spec metadata(error :: struct()) :: map()
  def metadata(error), do: error.__struct__.custom_data(error)
end
