# frozen_string_literal: true

require 'faraday'
require 'json'
require_relative 'unidade_federativa'
require_relative 'municipio'

# Variaveis

NOMES_POR_UF = 1
NOMES_POR_CIDADE = 2
NOMES_POR_PERIODO = 3
SAIR = 4

# Metodos

def bem_vindo
  puts
  puts '======== Seja bem-vind@ ao sistema de nomes do Brasil ========'
  puts
  listar_opcoes
end

def listar_opcoes
  puts 'Escolha a opção desejada:'
  puts
  puts "[#{NOMES_POR_UF}] Ranking dos nomes mais comuns por Unidade Federativa (UF)"
  puts "[#{NOMES_POR_CIDADE}] Ranking dos nomes mais comuns por cidade"
  puts "[#{NOMES_POR_PERIODO}] Frequência do uso de um nome por período"
  puts "[#{SAIR}] Sair"
  puts
end

def escolher_opcao
  print 'Digite o número da opção desejada: '
  gets.to_i
end

def opcao_invalida
  puts
  puts '======= Opção Inválida ======='
  puts
end

def tchau
  puts
  puts 'Obrigad@ por utilizar a aplicação de nomes do Brasil.'
  puts
end

def listar_ufs
  puts
  puts '======== Lista das Unidades Federativas ========'
  puts
  UnidadeFederativa.all.each { |uf| puts "[#{uf.sigla}] #{uf.nome}" }
  puts
end

def escolher_uf
  print 'Digite a sigla da UF desejada: '
  gets.chomp
end

def mostrar_nomes_por_uf(sigla)
  uf = UnidadeFederativa.encontrar_uf(sigla)
  if uf.nil?
    opcao_invalida
  else
    puts
    puts "======== Nomes mais frequentes - #{uf.nome} ========"
    puts
    uf.nomes_populares.each { |n| puts "#{n['ranking']} - #{n['nome']}" }
  end
end

def listar_municipios(sigla)
  uf = UnidadeFederativa.encontrar_uf(sigla)
  if uf.nil?
    opcao_invalida
  else
    puts
    puts "======== Municípios - #{uf.nome} ========"
    puts
    municipios = Municipio.all.select { |m| m.unidade_federativa == sigla }
    municipios.each { |m| puts m.nome.to_s }
  end
end

def escolher_municipio(sigla_uf)
  print 'Digite o nome do município: '
  nome = gets.chomp
  mostrar_nomes_por_municipio(nome, sigla_uf)
end

def mostrar_nomes_por_municipio(nome, sigla_uf)
  municipio = Municipio.all.find { |m| m.nome == nome && m.unidade_federativa == sigla_uf }
  if municipio
    puts
    puts "======== Nomes mais frequentes - #{municipio.nome}/#{sigla_uf} ========"
    puts
    municipio.nomes_populares.each { |n| puts "#{n['ranking']} - #{n['nome']}" }
  else
    opcao_invalida
  end
end

def frequencia_por_periodo(busca)
  response = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/#{busca.gsub(',', '%7C')}")
  json_response = JSON.parse(response.body)
  json_response.each do |array|
    puts array['nome']
    array['res'].each do |hash|
      puts "Período: #{hash['periodo']} - Frequência: #{hash['frequencia']}"
    end
  end
end

def busca_nomes
  print 'Digite um ou mais nomes (separados por vírgula) que deseja buscar:'
  busca = gets.chomp
  frequencia_por_periodo(busca)
end
