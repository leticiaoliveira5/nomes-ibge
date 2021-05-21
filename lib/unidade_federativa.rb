# frozen_string_literal: true

require 'active_record'

class UnidadeFederativa < ActiveRecord::Base
  has_many :municipios
  validates :nome, :sigla, :codigo, :populacao, presence: true
  validates :nome, :sigla, :codigo, uniqueness: true
end
