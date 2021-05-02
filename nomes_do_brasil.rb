require_relative 'lib/names_app'
require_relative 'db/db'

DB.connect
bem_vindo
opcao = escolher_opcao

loop do
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
    break
  else
    opcao_invalida
  end

  listar_opcoes
  opcao = escolher_opcao
end

DB.close
