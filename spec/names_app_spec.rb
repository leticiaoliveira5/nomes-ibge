# frozen_string_literal: true

require 'spec_helper'
require 'names_app'

RSpec.describe 'Names App' do
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
