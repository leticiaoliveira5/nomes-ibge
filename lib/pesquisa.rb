require 'active_record'
require_relative 'unidade_federativa'
require_relative 'municipio'
require_relative 'view'
require_relative 'api'

class Pesquisa
  def self.listar_ufs
    rows = []
    UnidadeFederativa.all.each { |uf| rows << [uf.sigla, uf.nome] }
    View.monta_tabela(title: 'Lista das Unidades Federativas', headings: %w[SIGLA NOME], rows: rows)
  end

  def self.listar_municipios(sigla_uf)
    municipios = Municipio.where(sigla_uf: sigla_uf)
    return View.opcao_invalida if municipios.nil?

    rows = []
    municipios.each { |municipio| rows << [municipio.nome] }
    View.monta_tabela(title: "Municípios - #{sigla_uf}", headings: [], rows: rows)
  end

  def self.nomes_por_uf(sigla)
    uf = UnidadeFederativa.find_by(sigla: sigla)
    return View.opcao_invalida if uf.nil?

    rows = []
    ranking_nomes(uf.codigo).each do |nome|
      rows << [nome[:ranking], nome[:nome], nome[:frequencia], percentual(nome[:frequencia], uf.populacao)]
    end
    View.monta_tabela(title: "Nomes mais frequentes - #{uf.nome}",
                      headings: %w[RANKING NOME FREQUÊNCIA PERCENTUAL], rows: rows)
    nomes_por_sexo(uf.codigo, uf.populacao)
  end

  def self.nomes_por_sexo(localidade, populacao)
    sexos = %w[M F]
    sexos.each do |sexo|
      response = Api.nomes("ranking?sexo=#{sexo}&localidade=#{localidade}")
      rows = []
      response[0][:res].each do |nome|
        rows << [nome[:ranking], nome[:nome], nome[:frequencia], percentual(nome[:frequencia], populacao)]
      end
      View.monta_tabela(title: "Nomes mais frequentes por sexo - #{sexo}",
                        headings: %w[RANKING NOME FREQUÊNCIA PERCENTUAL], rows: rows)
    end
  end

  def self.nomes_por_municipio(nome_municipio, sigla_uf)
    municipio = Municipio.find_by(nome: nome_municipio, sigla_uf: sigla_uf)
    return View.opcao_invalida if municipio.nil?

    rows = []
    ranking_nomes(municipio.codigo).each do |nome|
      rows << [nome[:ranking], nome[:nome], nome[:frequencia], percentual(nome[:frequencia], municipio.populacao)]
    end
    View.monta_tabela(title: "Nomes mais frequentes - #{municipio.nome}(#{sigla_uf})",
                      headings: %w[RANKING NOME FREQUÊNCIA PERCENTUAL], rows: rows)
    nomes_por_sexo(municipio.codigo, municipio.populacao)
  end

  def self.frequencia_por_periodo(busca)
    response = Api.nomes(busca.gsub(',', '%7C').to_s)
    return View.opcao_invalida if response.empty?

    nomes_por_periodo(response)
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

  # private

  def self.todos_os_nomes(response)
    response.map { |hash| hash[:nome] }.uniq.sort
  end

  def self.todos_os_periodos(response)
    response.map { |hash| hash[:res].map { |item| item[:periodo] } }.flatten.uniq.sort
  end

  def self.ranking_nomes(localidade)
    resposta = Api.nomes("ranking?localidade=#{localidade}")
    resposta[0][:res]
  end

  def self.percentual(frequencia, populacao)
    percentual = (frequencia.to_f / populacao) * 100
    "#{percentual.round(2)}%"
  end
end
