# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :customer

  validates :valor, numericality: { only_integer: true }
  validates :descricao, length: { maximum: 10 }
  validates :valor, :descricao, :tipo, presence: true
end
