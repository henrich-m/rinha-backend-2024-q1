# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessTransaction, :wip do
  describe '.call' do
    it 'calls the right processor' do
      customer = Customer.new(saldo: 0, limite: 0)
      transacation = customer.transactions.build(tipo: 'c', valor: 100_00, descricao: 'teste')

      expect { ProcessTransaction.new.call(transacation, customer) }.to change { customer.saldo }.from(0).to(100_00)
    end

    it 'updates the customer' do
      customer = Customer.new(saldo: 0, limite: 0)
      transacation = customer.transactions.build(tipo: 'c', valor: 100_00, descricao: 'teste')

      expect { ProcessTransaction.new.call(transacation, customer) }.to change { Customer.count }.by(1)
    end

    it 'persists the transaction' do
      customer = Customer.new(saldo: 0, limite: 0)
      transacation = customer.transactions.build(tipo: 'c', valor: 100_00, descricao: 'teste')

      expect { ProcessTransaction.new.call(transacation, customer) }.to change { Transaction.count }.by(1)
    end

    context 'with a invalid transaction tipo' do
      it 'raises UnkownProcessor error' do
        customer = Customer.new(saldo: 0, limite: 0)
        transacation = customer.transactions.build(tipo: 'a', valor: 100_00, descricao: 'teste')

        expect do
          ProcessTransaction.new.call(transacation, customer)
        end.to raise_error(ProcessTransaction::UnkownProcessor)
      end
    end
  end
end
