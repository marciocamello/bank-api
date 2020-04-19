defmodule BankApi.Plugs.VerifyRequest do
  defmodule IncompleteRequestError do
    @moduledoc """
      Error raised when a required field is missing.
    """

    defexception message: ""
  end

  @doc """
    Init plug
  """
  def init(options), do: options

  @doc """
    This is where we decide whether or not to apply our verification 
    Only when the request’s path is contained in our :paths option will we call `verify_request!/2`.
  """
  def call(%Plug.Conn{request_path: path} = conn, opts) do
    if path in opts[:paths], do: verify_request!(conn.params, opts[:fields])
    conn
  end

  @doc """
    verifies whether the required :fields are all present. 
    In the event that some are missing, we raise IncompleteRequestError
  """
  defp verify_request!(params, fields) do
    verified =
      params
      |> Map.keys()
      |> contains_fields?(fields)

    unless verified, do: raise(IncompleteRequestError)
  end

  @doc """
    Contain fields
  """
  defp contains_fields?(keys, fields), do: Enum.all?(fields, &(&1 in keys))
end
