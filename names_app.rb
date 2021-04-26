#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/names_app'

bem_vindo
opcao = escolher_opcao

loop do
  case opcao
  when NOMES_POR_UF
    listar_ufs
    sigla_da_uf = escolher_uf
    mostrar_nomes_por_uf(sigla_da_uf)
  when NOMES_POR_CIDADE
    listar_ufs
    sigla_da_uf = escolher_uf
    listar_municipios(sigla_da_uf)
    unless listar_municipios(sigla_da_uf).nil?
      nome = escolher_municipio
      mostrar_nomes_por_municipio(nome, sigla_da_uf)
    end
  # when NOMES_POR_PERIODO
  when SAIR
    tchau
    break
  else
    opcao_invalida
  end

  listar_opcoes
  opcao = escolher_opcao
end
