require 'faraday'
require 'json'
require 'active_record'
require_relative 'unidade_federativa'
require_relative 'municipio'
require_relative 'tabela'
require_relative 'view'

def listar_ufs
  rows = []
  UnidadeFederativa.all.each { |uf| rows << [uf.sigla, uf.nome] }
  Tabela.new(title: 'Lista das Unidades Federativas', headings: %w[SIGLA NOME], rows: rows)
end

def escolher_municipio(sigla_uf)
  print 'Digite o nome do município: '
  nome_municipio = gets.chomp.capitalize
  mostrar_nomes_por_municipio(nome_municipio, sigla_uf)
end

def mostrar_nomes_por_uf(sigla)
  uf = UnidadeFederativa.find_by(sigla: sigla)
  if uf
    rows = []
    nomes_populares(uf.codigo).each do |nome|
      percentual = (nome[:frequencia].to_f / uf.populacao) * 100
      rows << [nome[:ranking], nome[:nome], nome[:frequencia], "#{percentual.round(2)}%"]
    end
    Tabela.new(title: "Nomes mais frequentes - #{uf.nome}", headings: %w[RANKING NOME FREQUÊNCIA PERCENTUAL],
               rows: rows)
    nomes_por_sexo(uf.codigo, uf.populacao)
  else
    View.opcao_invalida
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
    Tabela.new(title: "Nomes mais frequentes por sexo - #{sexo}",
               headings: %w[RANKING NOME FREQUÊNCIA PERCENTUAL], rows: rows)
  end
end

def listar_municipios(sigla_uf)
  municipios = Municipio.where(sigla_uf: sigla_uf)
  if municipios.nil?
    View.opcao_invalida
  else
    rows = []
    municipios.each { |municipio| rows << [municipio.nome] }
    Tabela.new(title: "Municípios - #{sigla_uf}", headings: [], rows: rows)
  end
end

def mostrar_nomes_por_municipio(nome_municipio, sigla_uf)
  municipio = Municipio.find_by(nome: nome_municipio, sigla_uf: sigla_uf)
  if municipio.nil?
    View.opcao_invalida
  else
    rows = []
    nomes_populares(municipio.codigo).each do |nome|
      percentual = (nome[:frequencia].to_f / municipio.populacao) * 100
      rows << [nome[:ranking], nome[:nome], nome[:frequencia], "#{percentual.round(2)}%"]
    end
    Tabela.new(title: "Nomes mais frequentes - #{municipio.nome}(#{sigla_uf})",
               headings: %w[RANKING NOME FREQUÊNCIA PERCENTUAL], rows: rows)
    nomes_por_sexo(municipio.codigo, municipio.populacao)
  end
end

def mostra_frequencia_por_periodo(busca)
  resp = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/#{busca.gsub(',', '%7C')}")
  resp_json = JSON.parse(resp.body, symbolize_names: true)
  if resp_json.empty? || resp.status == 400
    View.sem_resultados
  else
    mostrar_nomes_por_periodo(resp_json)
  end
end

def mostrar_nomes_por_periodo(resp_json)
  rows = []
  nomes = []
  periodos = resp_json.map { |hash| hash[:res].map { |item| item[:periodo] } }.flatten
  periodos.uniq.sort.each do |periodo|
    row = [periodo]
    resp_json.each do |hash|
      nomes << hash[:nome]
      p = hash[:res].find { |item| item[:periodo] == periodo }
      p ? row << p[:frequencia] : row << '-'
      # {condition} ? {if-code-block} : {else-code-block}
    end
    rows << row
  end
  Tabela.new(title: 'Frequência do(s) nome(s) por período',
             headings: ['PERÍODO'] + nomes.uniq.sort, rows: rows)
end

def nomes_populares(codigo)
  resposta = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{codigo}")
  json_resposta = JSON.parse(resposta.body, symbolize_names: true)
  json_resposta[0][:res]
end
