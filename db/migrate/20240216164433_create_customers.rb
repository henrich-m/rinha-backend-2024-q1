# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.integer :limite
      t.integer :saldo

      t.timestamps
    end
  end
end
