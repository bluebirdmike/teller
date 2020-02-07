defmodule TellerAPI.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger
plug(Plug.Logger, log: :debug)

plug(:match)

plug(:dispatch)

  get "/accounts" do
    send_resp(conn, 200, Poison.encode!(get_all_accounts()))
  end

  get "/accounts/:account_id" do
    {status, body} = get_account(account_id)
    send_resp(conn, status, Poison.encode!(body))
  end

  get "/accounts/:account_id/transactions" do
    {status, body}= get_transactions_for_account(account_id)
    send_resp(conn, status, Poison.encode!(body))
  end


  match _ do
    send_resp(conn, 404, "not found")
  end

  defp get_all_accounts do
    accs = :ets.tab2list(:accounts)
    for {_,account} <- accs, do: account
  end

  defp get_account(account_id) do
    case :ets.lookup(:accounts, account_id) do
      [{_, account}] ->
        {200, account}
      _ ->
        {404, "Account Not Found"}
    end
  end

  defp get_transactions_for_account(account) do
    fun = fn({_, transaction}, {acc_id, transaction_list}) ->
            case transaction.account_id do
              ^acc_id ->
                {acc_id, [transaction|transaction_list]}
              _ ->
                {acc_id, transaction_list}
            end
    end
    case :ets.foldr(fun, {account, []}, :transactions) do
      {_, []} ->
        {404, "Transactions Not Found"}
      {_, transactions} ->
        # One new transaction is generated for account after each successful GET
        Transaction.add_transaction(account, Transaction.get_date())
        {200, transactions}
    end
  end

end
