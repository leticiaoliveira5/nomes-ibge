# frozen_string_literal: true

require 'terminal-table'
require 'faraday'
require 'json'
require 'active_record'
require_relative 'unidade_federativa'
require_relative 'municipio'
require_relative '../db/db'

# Variaveis

NOMES_POR_UF = 1
NOMES_POR_CIDADE = 2
NOMES_POR_PERIODO = 3
SAIR = 4

# Metodos

def carregar_dados
  puts 'Conectando ao banco de dados .....'
  DB.connect
  puts 'Criando tabelas.....'
  DB.create_tables
  puts 'Carregado os dados .........'
  DB.seed
  puts 'Tudo pronto pra começar'
end

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
  DB.close
end

def listar_ufs
  rows = []
  UnidadeFederativa.all.each { |uf| rows << [uf.sigla, uf.nome] }
  table = Terminal::Table.new title: 'Lista das Unidades Federativas', headings: %w[SIGLA NOME], rows: rows
  puts table
end

def escolher_uf
  print 'Digite a sigla da UF desejada: '
  sigla = gets.chomp
  if UnidadeFederativa.find_by(sigla: sigla)
    mostrar_nomes_por_uf(sigla)
  else
    opcao_invalida
  end
end

def mostrar_nomes_por_uf(sigla)
  uf = UnidadeFederativa.find_by(sigla: sigla)
  rows = []
  nomes_populares(uf.codigo).each { |n| rows << [n[:ranking], n[:nome], n[:frequencia]] }
  table = Terminal::Table.new title: "Nomes mais frequentes - #{uf.nome}",
                              headings: %w[RANKING NOME FREQUÊNCIA], rows: rows
  puts table
  nomes_por_sexo(uf.codigo)
end

def nomes_por_sexo(localidade)
  sexos = %w[M F]
  sexos.each do |sexo|
    resp = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?sexo=#{sexo}&localidade=#{localidade}")
    resp_json = JSON.parse(resp.body, symbolize_names: true)
    rows = []
    resp_json[0][:res].each { |hash| rows << [hash[:ranking], hash[:nome], hash[:frequencia]] }
    table = Terminal::Table.new title: "Nomes mais frequentes por sexo - #{sexo}",
                                headings: %w[RANKING NOME FREQUÊNCIA], rows: rows
    puts table
  end
end

def listar_municipios(sigla)
  uf = UnidadeFederativa.find_by(sigla: sigla)
  if uf.nil?
    opcao_invalida
  else
    puts "======== Municípios - #{uf.nome} ========"
    puts
    municipios = Municipio.where(unidade_federativa: sigla)
    municipios.each { |municipio| puts municipio.nome }
  end
end

def escolher_municipio(sigla_uf)
  print 'Digite o nome do município: '
  nome = gets.chomp
  if Municipio.find_by(nome: nome, unidade_federativa: sigla_uf)
    mostrar_nomes_por_municipio(nome, sigla_uf)
  else
    opcao_invalida
  end
end

def mostrar_nomes_por_municipio(nome, sigla_uf)
  municipio = Municipio.find_by(nome: nome, unidade_federativa: sigla_uf)
  rows = []
  nomes_populares(municipio.codigo).each { |n| rows << [n[:ranking], n[:nome], n[:frequencia]] }
  table = Terminal::Table.new title: "Nomes mais frequentes - #{municipio.nome}(#{sigla_uf})",
                              headings: %w[RANKING NOME FREQUÊNCIA], rows: rows
  puts table
  nomes_por_sexo(municipio.codigo)
end

def busca_nomes
  print 'Digite um ou mais nomes (separados por vírgula) que deseja buscar:'
  busca = gets.chomp
  frequencia_por_periodo(busca)
end

def frequencia_por_periodo(busca)
  resp = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/#{busca.gsub(',', '%7C').gsub(' ', '')}")
  resp_json = JSON.parse(resp.body, symbolize_names: true)
  if resp_json.empty?
    dicas_busca
  else
    mostrar_nomes_por_periodo(resp_json)
  end
end

def mostrar_nomes_por_periodo(resp_json)
  rows = []
  headings = ['PERÍODO']
  periodos = []
  resp_json.each do |hash|
    headings << hash[:nome]
    hash[:res].map { |h| periodos << h[:periodo] }.flatten
  end
  periodos = periodos.uniq.sort
  periodos.each do |periodo|
    row = []
    row << periodo
    resp_json.each do |hash|
      p = hash[:res].find { |a| a[:periodo] == periodo }
      p ? row << p[:frequencia] : row << '-'
      # {condition} ? {if-code-block} : {else-code-block}
    end
    rows << row
  end
  table = Terminal::Table.new title: 'Frequência do(s) nome(s) por período', headings: headings, rows: rows
  puts table
end

def dicas_busca
  puts
  puts 'O nome não foi encontrado.'
  puts
  puts '====== Dicas de busca ======='
  puts '- Não use acentos'
  puts '- Não use caracteres especiais,'
  puts 'apenas vírgula para separar os nomes'
  puts '- Não busque nomes compostos'
  puts
end

def nomes_populares(codigo)
  resposta = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{codigo}")
  json_resposta = JSON.parse(resposta.body, symbolize_names: true)
  json_resposta[0][:res]
end
