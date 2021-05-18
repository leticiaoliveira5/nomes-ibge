# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/view'
require_relative '../lib/names_app'
require_relative '../db/db'

DB.connect

RSpec.describe 'Names App' do
  context 'Iniciando aplicação' do
    it 'deve mostrar a mensagem de bem-vindo' do
      expect { View.bem_vindo }.to output(a_string_including('Seja bem-vind@ ao sistema de nomes do Brasil')).to_stdout
    end
    it 'deve mostrar opções de ação' do
      expect { View.listar_opcoes }.to output(include('Escolha a opção desejada:',
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
    it 'lista as municipios da UF escolhida' do
      expect { listar_municipios('SE') }.to output(include('Municípios - SE',
                                                           'Aquidabã',
                                                           'Areia Branca')).to_stdout
    end
  end

  context 'Resultados' do
    it 'mostra os nomes mais frequentes na UF' do
      expect { mostrar_nomes_por_uf('AC') }.to output(include('Nomes mais frequentes - Acre',
                                                              'RANKING', 'NOME', 'FREQUÊNCIA', 'PERCENTUAL',
                                                              '1', 'MARIA', '63172', '7.16%',
                                                              '2', 'JOSE', '24599', '2.79%')).to_stdout
    end
    it 'mostra erro caso a sigla recebida não corresponda a uma UF' do
      expect { mostrar_nomes_por_uf('SS') }.to output(a_string_including('Opção Inválida')).to_stdout
    end
    it 'mostra nomes mais frequentes no Municipio' do
      expect { mostrar_nomes_por_municipio('Tefé', 'AM') }.to output(include('Nomes mais frequentes - Tefé(AM)',
                                                                             '1', 'MARIA',
                                                                             '2', 'JOSE')).to_stdout
    end
    it 'mostra erro se município não existe' do
      expect { mostrar_nomes_por_municipio('Cabo', 'AM') }.to output(a_string_including('Opção Inválida')).to_stdout
    end
    it 'mostra frequência do nome buscado' do
      expect { mostra_frequencia_por_periodo('Mara,Maria') }.to output(include('MARA',
                                                                               '1930[', '254',
                                                                               '[1930,1940[', '582',
                                                                               'MARIA',
                                                                               '1930[', '336477',
                                                                               '[1930,1940[', '749053')).to_stdout
    end
    it 'mostra dicas caso a busca não retorne resultado' do
      expect do
        mostra_frequencia_por_periodo('Magaalii')
      end.to output(a_string_including('A busca não retornou nenhum resultado.')).to_stdout
    end
    it 'mostra tabelas com rakings de nomes por sexo na localidade' do
      expect { nomes_por_sexo('33', 17_264_943) }.to output(include('Nomes mais frequentes por sexo - F',
                                                                    'MARIA', 'ANA', 'MARCIA',
                                                                    'JULIANA', 'ADRIANA',
                                                                    'Nomes mais frequentes por sexo - M',
                                                                    'JOSE', 'JOAO', 'CARLOS',
                                                                    'PAULO', 'ANTONIO')).to_stdout
    end
  end
end
