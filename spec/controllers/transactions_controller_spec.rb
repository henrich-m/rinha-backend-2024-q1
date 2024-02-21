# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  describe '.create' do
    context 'when missing paramaters' do
      it 'returns status unprocessable_entity' do
        customer = Customer.create(saldo: 0, limite: 0)

        post :create, params: { id: customer.id }

        expect(response).to have_http_status(422)
      end
    end

    context 'when customer does not has funds' do
      it 'returns status unprocessable_entity' do
        customer = Customer.create(saldo: 0, limite: 0)

        post :create, params: { id: customer.id, tipo: 'd', valor: 10_00, descricao: 'aa' }

        expect(response).to have_http_status(422)
      end
    end

    context 'when transaction tipo is invalid' do
      it 'returns status unprocessable_entity' do
        customer = Customer.create(saldo: 0, limite: 0)

        post :create, params: { id: customer.id, tipo: 'a', valor: 10_00, descricao: 'aa' }

        expect(response).to have_http_status(422)
      end
    end

    context 'when transaction is invalid' do
      it 'returns status unprocessable_entity' do
        customer = Customer.create(saldo: 0, limite: 0)

        post :create, params: { id: customer.id, tipo: 'd', valor: 10_00, descricao: 'aaaaaaaaaaaaaaa' }

        expect(response).to have_http_status(422)
      end
    end

    context 'when customer does not exists' do
      it 'returns status not_found' do
        params = { id: 1 }

        post(:create, params:)

        expect(response).to have_http_status(404)
      end
    end

    it 'returns customer the saldo and limite' do
      customer = Customer.create(saldo: 0, limite: 0)

      post :create, params: { id: customer.id, tipo: 'c', valor: 10_00, descricao: 'aa' }

      expect(response.body).to eq({ limite: 0, saldo: 10_00 }.to_json)
    end
  end

  describe '.report' do
    context 'when customer does not exists' do
      it 'returns status not_found' do
        post :report, params: { id: 1 }

        expect(response).to have_http_status(404)
      end
    end

    context 'when customer exists' do
      it 'returns the report' do
        freeze_time do
          customer = Customer.create(saldo: 10_00, limite: 0)
          customer.transactions.create(tipo: 'c', valor: 10_00, descricao: 'a')

          post :report, params: { id: customer.id }

          expect(response.body).to eq(
            {
              'saldo' => {
                'total' => customer.saldo,
                'data_extrato' => Time.zone.now.iso8601(6),
                'limite' => customer.limite
              },
              'ultimas_transacoes' => customer.transactions.map do |transaction|
                {
                  'valor' => transaction.valor,
                  'tipo' => transaction.tipo,
                  'descricao' => transaction.descricao,
                  'realizada_em' => transaction.created_at.iso8601(6)
                }
              end
            }.to_json
          )
        end
      end
    end
  end
end
