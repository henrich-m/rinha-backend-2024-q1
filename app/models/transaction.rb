# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :customer

  validates :valor, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :descricao, length: { maximum: 10 }
  validates :valor, :descricao, :tipo, presence: true
end
