ActiveRecord::Schema.define do
  self.verbose = false

  enable_extension 'plpgsql'
  enable_extension 'pgcrypto'

  create_table(:unidade_federativas, force: true) do |t|
    t.string :sigla, null: false, unique: true
    t.string :nome, null: false, unique: true
    t.integer :codigo, null: false, unique: true
  end

  create_table(:municipios, force: true) do |t|
    t.string :nome, null: false
    t.integer :codigo, null: false, unique: true
    t.string :unidade_federativa, null: false, unique: true
  end
end
