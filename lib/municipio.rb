# frozen_string_literal: true

require 'active_record'

class Municipio < ActiveRecord::Base
  belongs_to :unidade_federativa
  validates :nome, :sigla_uf, :codigo, :populacao, :unidade_federativa, presence: true
  validates :codigo, uniqueness: true
end
