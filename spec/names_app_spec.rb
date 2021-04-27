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
      expect { listar_ufs }.to output(include('Lista das Unidades Federativas',
                                              'Acre', 'AC',
                                              'Amazonas', 'AM',
                                              'São Paulo', 'SP',
                                              'Tocantins', 'TO')).to_stdout
    end
    it 'Lista as municipios da UF escolhida' do
      expect { listar_municipios('SE') }.to output(include('Municípios - Sergipe',
                                                           'Aquidabã',
                                                           'Areia Branca')).to_stdout
    end
  end

  context 'Resultados' do
    it 'Mostra os nomes mais frequentes na UF' do
      expect { mostrar_nomes_por_uf('AC') }.to output(include(' Nomes mais frequentes - Acre ',
                                                              '1', 'MARIA',
                                                              '2', 'JOSE')).to_stdout
    end
    it 'Mostra erro caso a sigla recebida não corresponda a uma UF' do
      expect { mostrar_nomes_por_uf('SS') }.to output(a_string_including('Opção Inválida')).to_stdout
    end
    it 'Mostra nomes mais frequentes no Municipio' do
      expect { mostrar_nomes_por_municipio('Tefé', 'AM') }.to output(include('Nomes mais frequentes - Tefé/AM',
                                                                             '1', 'MARIA',
                                                                             '2', 'JOSE')).to_stdout
    end
    it 'Mostra erro se município não existe' do
      expect { mostrar_nomes_por_municipio('Cabo', 'AM') }.to output(a_string_including('Opção Inválida')).to_stdout
    end
    it 'Mostra frequência do nome buscado' do
      expect { frequencia_por_periodo('Mara,Maria') }.to output(include('MARA',
                                                                        '1930[', '254',
                                                                        '[1930,1940[', '582',
                                                                        'MARIA',
                                                                        '1930[', '336477',
                                                                        '[1930,1940[', '749053')).to_stdout
    end
  end
end
