defmodule BankApi.Plugs.VerifyRequest do
  defmodule IncompleteRequestError do
    @moduledoc """
      Error raised when a required field is missing.
    """

    defexception message: ""
  end
end
