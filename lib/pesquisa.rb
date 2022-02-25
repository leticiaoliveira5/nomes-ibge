require_relative 'view'
require_relative 'api'

PARSED_POPULATION_FILE = eval(File.read('data/parsed_population_data'))

class Pesquisa
  def self.listar_ufs
    rows = []
    Api.localidades('estados').each { |uf| rows << [uf[:sigla], uf[:nome]] }
    View.monta_tabela(title: 'Lista das Unidades Federativas',
                      headings: %w[SIGLA NOME], rows: rows)
  end

  def self.listar_municipios(sigla_uf)
    municipios = Api.municipios.select { |record| record[:microrregiao][:mesorregiao][:UF][:sigla] == sigla_uf }
    return View.opcao_invalida if municipios.empty?

    rows = []
    municipios.each { |municipio| rows << [municipio[:nome]] }
    View.monta_tabela(title: "Municípios - #{sigla_uf}", headings: [], rows: rows)
  end

  def self.nomes_por_uf(sigla)
    uf = Api.estados.find { |record| record[:sigla] == sigla }
    return View.opcao_invalida if uf.nil?

    ranking_nomes(0, uf)
    ranking_nomes('M', uf)
    ranking_nomes('F', uf)
  end

  def self.nomes_por_municipio(nome_municipio, sigla_uf)
    municipio = Api.municipios.find do |record|
      record[:microrregiao][:mesorregiao][:UF][:sigla] == sigla_uf && record[:nome] == nome_municipio
    end
    return View.opcao_invalida if municipio.nil?

    ranking_nomes(0, municipio)
    ranking_nomes('M', municipio)
    ranking_nomes('F', municipio)
  end

  def self.nomes_por_periodo(response)
    rows = []
    todos_os_periodos(response).each do |periodo|
      row = [periodo]
      response.each do |hash|
        match = hash[:res].find { |item| item[:periodo] == periodo }
        if match then row << match[:frequencia] else row << '-' end
      end
      rows << row
    end
    View.monta_tabela(title: 'Frequência do(s) nome(s) por período',
                      headings: ['PERÍODO'] + todos_os_nomes(response), rows: rows)
  end

  def self.ranking_nomes(sexo, localidade)
    resposta = Api.ranking_nomes(sexo, localidade[:id])
    rows = []
    resposta[0][:res].each do |nome|
      rows << [nome[:ranking], nome[:nome], nome[:frequencia],
               percentual(nome[:frequencia], populacao(resposta[0][:localidade].to_i))]
    end
    title = "Nomes mais frequentes - #{localidade[:nome]}"
    title << "- #{sexo}" if sexo != 0
    View.monta_tabela(title: title, headings: %w[RANKING NOME FREQUÊNCIA PERCENTUAL], rows: rows)
  end

  def self.frequencia_por_periodo(busca)
    response = Api.nomes(busca.gsub(',', '%7C').to_s)
    return View.opcao_invalida if response.empty?

    nomes_por_periodo(response)
  end

  def self.todos_os_nomes(response)
    response.map { |hash| hash[:nome] }.uniq.sort
  end

  def self.todos_os_periodos(response)
    response.map { |hash| hash[:res].map { |item| item[:periodo] } }.flatten.uniq.sort
  end

  def self.percentual(frequencia, populacao)
    percentual = (frequencia.to_f / populacao) * 100
    "#{percentual.round(2)}%"
  end

  def self.populacao(codigo_localidade)
    resultado = PARSED_POPULATION_FILE.find { |hash| hash['Cód.'].to_i == codigo_localidade }
    resultado ? resultado['População Residente - 2019'].to_f : 0
  end
end
