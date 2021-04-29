# frozen_string_literal: true

require 'pg'
require 'active_record'
require_relative '../db/db'

class UnidadeFederativa < ActiveRecord::Base
  # def self.encontrar_uf(sigla)
  #   sql = "SELECT * FROM UnidadeFederativa WHERE sigla = '#{sigla}'"
  #   # $db.execute(sql)
  #   connection.execute(sql)

  #   # UnidadeFederativa.all.find { |uf| uf.sigla == sigla.to_s }
  # end

  def nomes_populares(codigo)
    resposta = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{codigo}")
    json_resposta = JSON.parse(resposta.body, symbolize_names: true)
    json_resposta[0][:res]
  end
end
