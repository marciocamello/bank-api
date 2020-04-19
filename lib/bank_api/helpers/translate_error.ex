defmodule BankApi.Helpers.TranslateError do
  @moduledoc """
    Provides helper functions
  """

  @doc """
    Transform _changeset errors to pretty list
  """
  def pretty_errors(_changeset) do
    Ecto.Changeset.traverse_errors(_changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
