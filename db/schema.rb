ActiveRecord::Schema.define do
  self.verbose = false

  enable_extension 'plpgsql'
  enable_extension 'pgcrypto'

  create_table(:unidade_federativas, force: true) do |t|
    t.string :sigla, null: false, unique: true
    t.string :nome, null: false, unique: true
    t.integer :codigo, null: false, unique: true
    t.integer :populacao, null: false
  end

  create_table(:municipios, force: true) do |t|
    t.belongs_to :unidade_federativa, index: true
    t.string :nome, null: false
    t.string :sigla_uf, null: false
    t.integer :codigo, null: false, unique: true
    t.integer :populacao, null: false
  end
end
