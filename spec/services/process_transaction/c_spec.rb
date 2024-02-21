# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessTransaction::C, :wip do
  describe '.call' do
    it 'adds the value of operation to the balance' do
      customer = Customer.new(limite: 100_00, saldo: 0)

      transaction = customer.transactions.build(tipo: 'c', valor: 90_00, descricao: 'deposito')

      ProcessTransaction::C.new.call(transaction, customer)
      expect(customer.saldo).to eq(90_00)
    end
  end
end
