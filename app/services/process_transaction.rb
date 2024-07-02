# frozen_string_literal: true

class ProcessTransaction
  class NotEnoughFunds < RuntimeError; end
  class UnkownProcessor < RuntimeError; end

  def call(transaction, customer)
    customer.with_lock do
      processors(transaction.tipo).new.call(transaction, customer)
      customer.save!
    end
    transaction.save!
  end

  private

  def processors(tipo)
    {
      'c' => C,
      'd' => D
    }.fetch(tipo)
  rescue KeyError => _e
    raise UnkownProcessor, 'Invalid transaction tipo'
  end
end
