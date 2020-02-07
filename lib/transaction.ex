defmodule Transaction do
  defstruct type: nil,
            running_balance: nil,
            links: nil,
            id: nil,
            description: nil,
            date: nil,
            amount: nil,
            account_id: nil

  @type t :: %Transaction{
    type: String.t(),
    running_balance: Float.t(),
    links: Links.t(),
    id: String.t(),
    description: String.t(),
    date: String.t() | nil,
    amount: Float.t() | nil,
    account_id: String.t()
  }

  def generate do
    # Generate initial transactions (5) for each account
    for account_id <- ["1001", "1002", "1003"], do:
      :ok = generate_account_transactions(account_id, 5)
  end

  def generate_account_transactions(_, 0) do
    :ok
  end
  def generate_account_transactions(account_id, n) do
    add_transaction(account_id, Date.add(get_date(), n*-15))
    generate_account_transactions(account_id, n-1)
  end

  # Creates new transaction with date for the given account ID
  def add_transaction(account_id, date) do
    amount = random_float()
    new_bal = update_account_balance(account_id, amount)
    transaction_id = generate_new_transaction_id()
    transaction = %Transaction{type: Enum.random(["card payment", "bank transfer"]),
                               running_balance: new_bal,
                               links: %{self: Enum.join(["http://localhost/accounts/test_1001/", transaction_id]),
                                        account: Enum.join(["http://localhost/accounts/", account_id])},
                               id: transaction_id,
                               description: "test transaction",
                               date: Date.to_string(date),
                               amount: amount,
                               account_id: account_id
                              }
    :ets.insert(:transactions, {transaction_id, transaction})
  end

  # Update account balance with transaction amount
  @spec update_account_balance(any, number) :: number
  def update_account_balance(account_id, amount) do
    [{_, acc}] = :ets.lookup(:accounts, account_id)
    newbal = %Balance{available: Float.round(acc.balances.available + amount, 2),
                      ledger: Float.round(acc.balances.ledger + amount, 2)}
    :ets.insert(:accounts, {account_id, %Account{acc | balances: newbal }})
    Float.round(acc.balances.available + amount, 2)
  end

  # Returns the next available transaction id
  def generate_new_transaction_id() do
    case :ets.last(:transactions) do
      :'$end_of_table' ->
        "test_txn_10000000001"
      last ->
        newid = 1 + :erlang.binary_to_integer(:string.slice(last, 9))
        Enum.join(["test_txn_", :erlang.integer_to_list(newid)])
    end
  end

  # Return current date
  def get_date do
    {erldate, _} = :erlang.localtime()
    {:ok, date} = Date.from_erl(erldate)
    date
  end

  # Generate a random float
  def random_float() do
    int = Enum.random(-500..1000)
    dp = Enum.random(0..99)
    :erlang.binary_to_float(Enum.join([:erlang.integer_to_list(int), "." ,:erlang.integer_to_list(dp)]))
  end

end
