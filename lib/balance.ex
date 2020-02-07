defmodule Balance do
  defstruct available: nil,
            ledger: nil

  @type t :: %Balance{
    available: Float.t(),
    ledger: Float.t()
  }
end
