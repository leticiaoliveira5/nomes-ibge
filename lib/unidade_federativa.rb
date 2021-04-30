# frozen_string_literal: true

require 'active_record'
require 'smarter_csv'

class UnidadeFederativa < ActiveRecord::Base
  def populacao
    output = SmarterCSV.process('data/populacao_2019.csv')
    resultado = output.find { |hash| hash[:"cód."] == codigo }
    resultado[:população_residente___2019].to_f
  end
end
