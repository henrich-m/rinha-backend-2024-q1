# frozen_string_literal: true

class ProcessTransaction
  class C
    def call(transaction, customer)
      customer.saldo += transaction.valor
    end
  end
end
