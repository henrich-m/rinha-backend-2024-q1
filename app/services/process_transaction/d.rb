# frozen_string_literal: true

class ProcessTransaction
  class D
    def call(transaction, customer)
      balance = customer.saldo - transaction.valor

      if balance.positive? || balance.zero? || balance >= (customer.limite * -1)
        Customer.decrement_counter(:saldo, customer.id, by: transaction.valor)
        # customer.saldo = balance
        return
      end

      raise NotEnoughFunds, 'Not enough funds in account.'
    end
  end
end
