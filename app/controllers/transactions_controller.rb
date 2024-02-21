# frozen_string_literal: true

class TransactionsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, ActionController::ParameterMissing, ProcessTransaction::UnkownProcessor,
              ProcessTransaction::NotEnoughFunds do |exception|
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: exception.message }, status: :not_found
  end

  def create
    customer = Customer.lock.find(customer_params)
    transaction = customer.transactions.build(transaction_params)

    ProcessTransaction.new.call(transaction, customer)

    render json: {
      'limite' => customer.limite,
      'saldo' => customer.saldo
    }
  end

  def report
    customer = Customer.includes(:transactions).find(customer_params)

    render json: {
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
    }
  end

  private

  def transaction_params
    params.permit(:valor, :tipo, :descricao).tap do |person_params|
      person_params.require(:valor)
      person_params.require(:tipo)
      person_params.require(:descricao)
    end
  end

  def customer_params
    params.require(:id)
  end
end
