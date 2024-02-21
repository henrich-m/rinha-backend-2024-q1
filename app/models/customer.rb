# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :transactions, -> { order('created_at DESC') }
end
