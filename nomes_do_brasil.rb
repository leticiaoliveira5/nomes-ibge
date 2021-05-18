require_relative 'lib/names_app'
require_relative 'lib/view'
require_relative 'db/db'

DB.connect
View.bem_vindo
opcao = View.escolher_opcao

loop do
  case opcao
  when NOMES_POR_UF
    listar_ufs
    sigla_uf = View.escolher_uf
    mostrar_nomes_por_uf(sigla_uf)
  when NOMES_POR_CIDADE
    listar_ufs
    sigla_uf = View.escolher_uf
    listar_municipios(sigla_uf)
    escolher_municipio(sigla_uf)
  when NOMES_POR_PERIODO
    busca_nomes
  when SAIR
    View.tchau
    break
  else
    View.opcao_invalida
  end

  listar_opcoes
  opcao = escolher_opcao
end

DB.close
