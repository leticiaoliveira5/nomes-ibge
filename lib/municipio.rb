# frozen_string_literal: true

require 'faraday'
require 'json'

class Municipio
  attr_reader :nome, :codigo, :unidade_federativa

  def initialize(nome, codigo, unidade_federativa)
    @nome = nome
    @codigo = codigo
    @unidade_federativa = unidade_federativa
  end

  def self.all
    response = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/municipios')

    return [] if response.status == 400

    json_response = JSON.parse(response.body, symbolize_names: true)
    json_response.map do |obj|
      Municipio.new(obj[:nome], obj[:id], obj[:regiao-imediata][:regiao-intermediaria][:UF][:sigla])
    end
  end

  def nomes_populares
    resposta = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{codigo}")
    resposta_json = JSON.parse(resposta.body, symbolize_names: true)
    resposta_json[0][:res]
  end
end
