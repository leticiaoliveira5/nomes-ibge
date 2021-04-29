# frozen_string_literal: true

require 'faraday'
require 'json'
require_relative '../db/db'

class UnidadeFederativa
  attr_reader :nome, :sigla, :codigo

  def initialize(sigla, nome, codigo)
    @sigla = sigla
    @nome = nome
    @codigo = codigo
  end

  def self.create(sigla, nome, codigo)
    sql = "INSERT INTO UnidadeFederativa (sigla, nome, codigo)
           VALUES ('#{sigla}', '#{nome}', #{codigo})"
    $db.exec(sql)
  end

  def self.all
    response = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')
    json_response = JSON.parse(response.body, symbolize_names: true)
    json_response.map { |obj| UnidadeFederativa.new(obj[:sigla], obj[:nome], obj[:id]) }
  end

  def self.encontrar_uf(sigla)
    UnidadeFederativa.all.find { |uf| uf.sigla == sigla.to_s }
  end

  def nomes_populares
    resposta = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{codigo}")
    json_resposta = JSON.parse(resposta.body, symbolize_names: true)
    json_resposta[0][:res]
  end
end
