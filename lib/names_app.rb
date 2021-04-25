# frozen_string_literal: true
require_relative 'unidade_federativa'
# Variaveis

NOMES_POR_UF = 1
NOMES_POR_CIDADE = 2
NOMES_POR_PERIODO = 3
SAIR = 4

# Metodos

def bem_vindo
  puts '======== Seja bem-vind@ ao sistema de nomes do Brasil ========'
end

def listar_opcoes
  puts 'Escolha a opção desejada:'
  puts "[#{NOMES_POR_UF}] Ranking dos nomes mais comuns por Unidade Federativa (UF)"
  puts "[#{NOMES_POR_CIDADE}] Ranking dos nomes mais comuns por cidade"
  puts "[#{NOMES_POR_PERIODO}] Frequência do uso de um nome por período"
  puts "[#{SAIR}] Sair"
end

def escolher_opcao
  print 'Digite o número da opção desejada: '
  gets.to_i
end

def listar_ufs
  puts '======== Lista das Unidades Federativas ========'
  UnidadeFederativa.all.each { |uf| puts "[#{uf.sigla}] #{uf.nome}" }
end

def escolher_uf
  print 'Digite a sigla da UF desejada: '
  gets.chomp
end
