# frozen_string_literal: true

class ProcessTransaction
  class C
    def call(transaction, customer)
      # customer.saldo += transaction.valor
      Customer.increment_counter(:saldo, customer.id, by: transaction.valor)
    end
  end
end
