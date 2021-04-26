# frozen_string_literal: true

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

def escolher_municipio
  print 'Digite o nome do município: '
  gets.chomp
end
