require_relative 'names_app'

NOMES_POR_UF = 1
NOMES_POR_CIDADE = 2
NOMES_POR_PERIODO = 3
SAIR = 4

class View
  def self.bem_vindo
    puts "\n======== Seja bem-vind@ ao sistema de nomes do Brasil ========\n\n"
    listar_opcoes
  end

  def self.listar_opcoes
    puts "Escolha a opção desejada:\n\n"
    puts "[#{NOMES_POR_UF}] Ranking dos nomes mais comuns por Unidade Federativa (UF)"
    puts "[#{NOMES_POR_CIDADE}] Ranking dos nomes mais comuns por cidade"
    puts "[#{NOMES_POR_PERIODO}] Frequência do uso de um nome por período"
    puts "[#{SAIR}] Sair\n\n"
  end

  def self.escolher_opcao
    print 'Digite o número da opção desejada: '
    opcao = gets.to_i
    loop(opcao)
  end

  def self.opcao_invalida
    puts "\n======= Opção Inválida =======\n"
  end

  def self.sem_resultados
    puts "\n A busca não retornou nenhum resultado. \n"
  end

  def self.dicas_busca
    puts "\n  ===== Dicas de busca ===== "
    puts '- Não use caracteres especiais, acentos ou espaços,'
    puts '  apenas vírgula para separar os nomes.'
    puts '- Esta API não retorna resultados ao consultar nomes compostos.'
    puts '- A quantidade mínima de ocorrências para que seja divulgado os'
    puts "  resultados é de 10 por município, 15 por Unidade da Federação e 20 no Brasil.\n\n"
  end

  def self.tchau
    puts "\nObrigad@ por utilizar a aplicação de nomes do Brasil.\n"
  end

  def self.escolher_uf
    print 'Digite a sigla da UF desejada: '
    gets.chomp.upcase
  end

  def self.busca_nomes
    dicas_busca
    print 'Digite um ou mais nomes (separados por vírgula) que deseja buscar:'
    input = gets.chomp
    busca = input.downcase.tr('àáâãäçèéêëĕìíîïĭñòóôõöùúûüũýŷ', 'aaaaaceeeeeiiiiinooooouuuuuyy').gsub(
      /[¨_-´`+=ºª§!@#$%^&*(),;.?":{}|<~>] /, ''
    )
    mostra_frequencia_por_periodo(busca)
  end

  def self.loop(opcao)
    case opcao
    when NOMES_POR_UF
      listar_ufs
      sigla_uf = escolher_uf
      mostrar_nomes_por_uf(sigla_uf)
    when NOMES_POR_CIDADE
      listar_ufs
      sigla_uf = escolher_uf
      listar_municipios(sigla_uf)
      escolher_municipio(sigla_uf)
    when NOMES_POR_PERIODO
      busca_nomes
    when SAIR
      tchau
    else
      opcao_invalida
    end

    return if opcao == SAIR

    listar_opcoes
    escolher_opcao
  end
end
