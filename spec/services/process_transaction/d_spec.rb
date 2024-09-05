# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessTransaction::D do
  describe '.call' do
    context 'when customer has enough balance' do
      it 'deduces the value from balance' do
        customer = Customer.new(limite: 0, saldo: 100_000)

        transaction = customer.transactions.build(tipo: 'd', valor: 100_00, descricao: 'compra')

        ProcessTransaction::D.new.call(transaction, customer)
        expect(customer.saldo).to eq(0)
      end
    end

    context 'when customer does not has enough balance' do
      it 'raises the NotEnoughFunds exception' do
        customer = Customer.new(limite: 10_00, saldo: 0)
        transaction = customer.transactions.build(tipo: 'd', valor: 100_00, descricao: 'compra')

        expect do
          ProcessTransaction::D.new.call(transaction, customer)
        end.to raise_error(ProcessTransaction::NotEnoughFunds)
      end
    end

    context 'when customer has enough limit' do
      it 'deduces the value from balance' do
        customer = Customer.new(limite: 100_00, saldo: 0)

        transaction = customer.transactions.build(tipo: 'd', valor: 90_00, descricao: 'compra')

        ProcessTransaction::D.new.call(transaction, customer)
        expect(customer.saldo).to eq(-90_00)
      end
    end

    context 'when customer does not has enough limit' do
      it 'raises the NotEnoughFunds exception' do
        customer = Customer.new(limite: 10_00, saldo: 0)

        transaction = customer.transactions.build(tipo: 'd', valor: 100_00, descricao: 'compra')

        expect do
          ProcessTransaction::D.new.call(transaction, customer)
        end.to raise_error(ProcessTransaction::NotEnoughFunds)
      end
    end
  end
end
