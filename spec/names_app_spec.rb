# frozen_string_literal: true

require 'spec_helper'
require 'names_app'

RSpec.describe 'Names App' do
  context 'Iniciando aplicação' do
    it 'deve mostrar a mensagem de bem-vindo' do
      expect { bem_vindo }.to output(a_string_including('Seja bem-vind@ ao sistema de nomes do Brasil')).to_stdout
    end
    it 'deve mostrar opções de ação' do
      expect { listar_opcoes }.to output(include('Escolha a opção desejada:',
                                                 '[1] Ranking dos nomes mais comuns por Unidade Federativa (UF)',
                                                 '[2] Ranking dos nomes mais comuns por cidade',
                                                 '[3] Frequência do uso de um nome por período',
                                                 '[4] Sair')).to_stdout
    end
  end

  context 'Opções' do
    it 'deve listar as UFs' do
      expect { listar_ufs }.to output(include('======== Lista das Unidades Federativas ========',
                                              '[AC] Acre',
                                              '[AM] Amazonas',
                                              '[SP] São Paulo',
                                              '[TO] Tocantins')).to_stdout
    end

    it 'Mostra erro caso a sigla recebida não corresponda a uma UF' do
      expect { mostrar_nomes_por_uf('SS') }.to output(a_string_including('Opção Inválida')).to_stdout
    end

    it 'Mostra os nomes mais frequentes na UF' do
      expect { mostrar_nomes_por_uf('AC') }.to output(include(' Nomes mais frequentes - Acre ',
                                                              '1 - MARIA',
                                                              '2 - JOSE')).to_stdout
    end

    it 'Lista as municipios da UF escolhida' do
      expect { listar_municipios('SE') }.to output(include('Municípios - Sergipe', 
                                                           'Aquidabã', 
                                                           'Areia Branca')).to_stdout
    end
  end
end
