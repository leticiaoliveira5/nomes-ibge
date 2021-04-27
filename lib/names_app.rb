# frozen_string_literal: true

require 'terminal-table'
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
  rows = []
  UnidadeFederativa.all.each { |uf| rows << [uf.sigla, uf.nome] }
  table = Terminal::Table.new title: 'Lista das Unidades Federativas', headings: %w[Sigla Nome], rows: rows
  puts table
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
    rows = []
    uf.nomes_populares.each { |n| rows << [n['ranking'], n['nome']] }
    table = Terminal::Table.new title: "Nomes mais frequentes - #{uf.nome}", headings: %w[Ranking Nome], rows: rows
    puts table
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
    rows = []
    municipio.nomes_populares.each { |n| rows << [n['ranking'], n['nome']] }
    table = Terminal::Table.new title: "Nomes mais frequentes - #{municipio.nome}(#{sigla_uf})",
                                headings: %w[Ranking Nome], rows: rows
    puts table
  else
    opcao_invalida
  end
end

def frequencia_por_periodo(busca)
  response = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/#{busca.gsub(',', '%7C').gsub(' ', '')}")
  json_response = JSON.parse(response.body)
  if json_response.empty?
    dicas_busca
  else
    rows = []
    periodos = []
    headings = ['Período']
    json_response.each do |hash| 
      headings << hash['nome']
      hash['res'].map { |h| periodos << h['periodo'] }
    end
    periodos = periodos.uniq.sort
    periodos.each do |periodo|
      row = []
      row << periodo
      json_response.each do |hash|
        if hash['res'].find { |h| h.key(periodo.to_s) }.nil?
          row << '-'
        else
          hash['res'].each { |a| row << a['frequencia'] if a['periodo'] == periodo }
        end
      end
      rows << row
    end
    table = Terminal::Table.new title: 'Frequência do(s) nome(s) por período', headings: headings, rows: rows
    puts table
  end
end

def busca_nomes
  print 'Digite um ou mais nomes (separados por vírgula) que deseja buscar:'
  busca = gets.chomp
  frequencia_por_periodo(busca)
end

def dicas_busca
  puts
  puts 'O nome não foi encontrado.'
  puts
  puts '====== Dicas de busca ======='
  puts '- Não use acentos'
  puts '- Não use caracteres especiais, apenas vírgula para separar os nomes'
  puts '- Não busque nomes compostos'
  puts
end
