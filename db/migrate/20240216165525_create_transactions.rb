# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.integer :valor
      t.string :tipo, limit: 1
      t.string :descricao, limit: 10
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
