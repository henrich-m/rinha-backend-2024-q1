# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

[
  { id: 1, limite: 1_000_00, saldo: 0 },
  { id: 2, limite: 800_00, saldo: 0 },
  { id: 3, limite: 10_000_00, saldo: 0 },
  { id: 4, limite: 100_000_00, saldo: 0 },
  { id: 5, limite: 5_000_00, saldo: 0 }
].each do |data|
  Customer.create(data)
end
