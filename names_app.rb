#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/names_app'

bem_vindo
listar_opcoes
opcao = escolher_opcao

loop do
  case opcao
  when NOMES_POR_UF
    listar_ufs
    sigla = escolher_uf
    mostrar_nomes_por_uf(sigla)
  when NOMES_POR_CIDADE
    listar_ufs
  # when NOMES_POR_PERIODO
  when SAIR
    break
  else
    opcao_invalida
  end

  listar_opcoes
  opcao = escolher_opcao
end
