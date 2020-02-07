defmodule TellerApi.Application do

  use Application
  def start(_type, _args) do
    :ets.new(:accounts, [:set, :public, :named_table])
    :ets.new(:transactions, [:ordered_set, :public, :named_table])
    # Generate initial data
    Account.generate()
    Transaction.generate()
    children = [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: TellerAPI.Router, options: [port: 8080])
    ]

    opts = [strategy: :one_for_one, name: TellerAPI.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
