require 'terminal-table'
require 'faraday'
require 'json'
require 'active_record'
require_relative 'unidade_federativa'
require_relative 'municipio'

# Variaveis

NOMES_POR_UF = 1
NOMES_POR_CIDADE = 2
NOMES_POR_PERIODO = 3
SAIR = 4

# Metodos

def bem_vindo
  puts "\n======== Seja bem-vind@ ao sistema de nomes do Brasil ========\n\n"
  listar_opcoes
end

def listar_opcoes
  puts "Escolha a opção desejada:\n\n"
  puts "[#{NOMES_POR_UF}] Ranking dos nomes mais comuns por Unidade Federativa (UF)"
  puts "[#{NOMES_POR_CIDADE}] Ranking dos nomes mais comuns por cidade"
  puts "[#{NOMES_POR_PERIODO}] Frequência do uso de um nome por período"
  puts "[#{SAIR}] Sair\n\n"
end

def escolher_opcao
  print 'Digite o número da opção desejada: '
  gets.to_i
end

def opcao_invalida
  puts "\n======= Opção Inválida =======\n"
end

def sem_resultados
  puts "\n A busca não retornou nenhum resultado. \n"
end

def dicas_busca
  puts "\n  ===== Dicas de busca ===== "
  puts '- Não use caracteres especiais, acentos ou espaços,'
  puts '  apenas vírgula para separar os nomes.'
  puts '- Esta API não retorna resultados ao consultar nomes compostos.'
  puts '- A quantidade mínima de ocorrências para que seja divulgado os'
  puts "  resultados é de 10 por município, 15 por Unidade da Federação e 20 no Brasil.\n\n"
end

def tchau
  puts "\nObrigad@ por utilizar a aplicação de nomes do Brasil.\n"
end

def listar_ufs
  rows = []
  UnidadeFederativa.all.each { |uf| rows << [uf.sigla, uf.nome] }
  table = Terminal::Table.new title: 'Lista das Unidades Federativas', headings: %w[SIGLA NOME], rows: rows
  puts table
end

def escolher_uf
  print 'Digite a sigla da UF desejada: '
  gets.chomp.upcase
end

def escolher_municipio(sigla_uf)
  print 'Digite o nome do município: '
  nome = gets.chomp
  mostrar_nomes_por_municipio(nome, sigla_uf)
end

def mostrar_nomes_por_uf(sigla)
  uf = UnidadeFederativa.find_by(sigla: sigla)
  if uf
    rows = []
    nomes_populares(uf.codigo).each do |n|
      percentual = (n[:frequencia].to_f / uf.populacao) * 100
      rows << [n[:ranking], n[:nome], n[:frequencia], "#{percentual.round(2)}%"]
    end
    table = Terminal::Table.new title: "Nomes mais frequentes - #{uf.nome}",
                                headings: %w[RANKING NOME FREQUÊNCIA PERCENTUAL], rows: rows
    puts table
    nomes_por_sexo(uf.codigo, uf.populacao)
  else
    opcao_invalida
  end
end

def nomes_por_sexo(localidade, populacao)
  sexos = %w[M F]
  sexos.each do |sexo|
    resp = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?sexo=#{sexo}&localidade=#{localidade}")
    resp_json = JSON.parse(resp.body, symbolize_names: true)
    rows = []
    resp_json[0][:res].each do |nome|
      percentual = (nome[:frequencia].to_f / populacao) * 100
      rows << [nome[:ranking], nome[:nome], nome[:frequencia], "#{percentual.round(2)}%"]
    end
    table = Terminal::Table.new title: "Nomes mais frequentes por sexo - #{sexo}",
                                headings: %w[RANKING NOME FREQUÊNCIA PERCENTUAL], rows: rows
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

def mostrar_nomes_por_municipio(nome, sigla_uf)
  municipio = Municipio.find_by(nome: nome, unidade_federativa: sigla_uf)
  if municipio.nil?
    opcao_invalida
  else
    rows = []
    nomes_populares(municipio.codigo).each do |n|
      percentual = (n[:frequencia].to_f / municipio.populacao) * 100
      rows << [n[:ranking], n[:nome], n[:frequencia], "#{percentual.round(2)}%"]
    end
    table = Terminal::Table.new title: "Nomes mais frequentes - #{municipio.nome}(#{sigla_uf})",
                                headings: %w[RANKING NOME FREQUÊNCIA PERCENTUAL], rows: rows
    puts table
    nomes_por_sexo(municipio.codigo, municipio.populacao)
  end
end

def busca_nomes
  dicas_busca
  print 'Digite um ou mais nomes (separados por vírgula) que deseja buscar:'
  input = gets.chomp
  busca = input.downcase.tr('àáâãäçèéêëĕìíîïĭñòóôõöùúûüũýŷ', 'aaaaaceeeeeiiiiinooooouuuuuyy').gsub(
    /[¨_-´`+=ºª§!@#$%^&*(),;.?":{}|<~>] /, ''
  )
  frequencia_por_periodo(busca)
end

def frequencia_por_periodo(busca)
  resp = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/#{busca.gsub(',', '%7C')}")
  resp_json = JSON.parse(resp.body, symbolize_names: true)
  if resp_json.empty? || resp.status == 400
    sem_resultados
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

def nomes_populares(codigo)
  resposta = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{codigo}")
  json_resposta = JSON.parse(resposta.body, symbolize_names: true)
  json_resposta[0][:res]
end
