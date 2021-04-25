# frozen_string_literal: true

require_relative 'unidade_federativa'

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

def listar_ufs
  puts
  puts '======== Lista das Unidades Federativas ========'
  UnidadeFederativa.all.each { |uf| puts "[#{uf.sigla}] #{uf.nome}" }
  puts
end

def escolher_uf
  print 'Digite a sigla da UF desejada: '
  gets.chomp
end

def mostrar_nomes_por_uf(sigla)
  response = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados')
  json_response = JSON.parse(response.body)
  unidade_federativa = json_response.select { |uf| uf['sigla'] == sigla.to_s }
  if unidade_federativa.empty?
    opcao_invalida
  else
    puts
    puts "======== Nomes mais frequentes - #{unidade_federativa[0]['nome']} ========"
    puts
    codigo = unidade_federativa[0]['id']
    resposta = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{codigo}")
    json_resposta = JSON.parse(resposta.body)
    json_resposta[0]['res'].each { |uf| puts "#{uf['ranking']} - #{uf['nome']}" }
  end
end