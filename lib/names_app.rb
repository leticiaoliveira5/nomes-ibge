NOMES_POR_UF = 1
NOMES_POR_CIDADE = 2
NOMES_POR_PERIODO = 3
SAIR = 4

def bem_vindo
  puts '======== Seja bem-vindo ao sistema de nomes do Brasil ========'
end

def listar_opcoes
  puts 'Escolha a opção desejada:'
  puts "[#{NOMES_POR_UF}] Ranking dos nomes mais comuns por Unidade Federativa (UF)"
  puts "[#{NOMES_POR_CIDADE}] Ranking dos nomes mais comuns por cidade"
  puts "[#{NOMES_POR_PERIODO}] Frequência do uso de um nome por período"
  puts "[#{SAIR}] Sair"
end

bem_vindo
listar_opcoes
