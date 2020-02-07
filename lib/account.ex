defmodule Account do
  @enforce_keys [:id]
  defstruct id: nil,
            account_number: nil,
            balances: nil,
            currency_code: nil,
            enrollment_id: nil,
            institution: nil,
            links: nil,
            name: nil,
            routing_numbers: nil

  @type t :: %Account{
    id: String.t(),
    account_number: String.t(),
    balances: Balance.t() | nil,
    currency_code: String.t(),
    enrollment_id: String.t(),
    institution: Tuple.t() | nil,
    links: Tuple.t() | nil,
    name: String.t(),
    routing_numbers: Routing_numbers.t() | nil
  }

  def generate do
    # Create 3 accounts
    acc_one = %Account{id: "1001",
                      account_number: "test_1001",
                      balances: %Balance{available: 0.0,
                                          ledger: 0.0},
                      currency_code: "USD",
                      enrollment_id: "test_enr_1001",
                      institution: %{id: "teller_bank",
                                     name: "The Teller Bank"},
                      links: %{self: "http://localhost/accounts/test_1001",
                              transactions: "http://localhost/accounts/test_1001/transactions"},
                      name: "Test Account 1",
                      routing_numbers: %{ach: "145614684",
                                         wire: "165161465"}
                      }
    acc_two = %Account{id: "1002",
                      account_number: "test_1002",
                      balances: %Balance{available: 0.0,
                                          ledger: 0.0},
                      currency_code: "USD",
                      enrollment_id: "test_enr_1002",
                      institution: %{id: "teller_bank",
                                     name: "The Teller Bank"},
                      links: %{self: "http://localhost/accounts/test_1002",
                               transactions: "http://localhost/accounts/test_1002/transactions"},
                      name: "Test Account 2",
                      routing_numbers: %{ach: "9846354138",
                                         wire: "1325454664"}
                      }
    acc_three = %Account{id: "1003",
                        account_number: "test_1003",
                        balances: %Balance{available: 0.0,
                                           ledger: 0.0},
                        currency_code: "USD",
                        enrollment_id: "test_enr_1003",
                        institution: %{id: "teller_bank",
                                       name: "The Teller Bank"},
                        links: %{self: "http://localhost/accounts/test_1003",
                                 transactions: "http://localhost/accounts/test_1003/transactions"},
                        name: "Test Account 3",
                        routing_numbers: %{ach: "1541684215",
                                           wire: "2335155865"}
                    }
    :ets.insert(:accounts, {"1001", acc_one})
    :ets.insert(:accounts, {"1002", acc_two})
    :ets.insert(:accounts, {"1003", acc_three})
  end
end


