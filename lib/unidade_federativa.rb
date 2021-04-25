require 'faraday'
require 'json'

class UnidadeFederativa
  
  attr_reader :nome, :sigla

  def initialize(sigla, nome)
    @sigla = sigla
    @nome = nome
  end

  def self.all
    response = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')

    return [] if response.status == 400

    json_response = JSON.parse(response.body)
    json_response.map { |obj| UnidadeFederativa.new(obj["sigla"], obj['nome']) }
  end
end
