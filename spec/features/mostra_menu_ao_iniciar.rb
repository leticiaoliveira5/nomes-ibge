require 'spec_helper'
require_relative '../../lib/view'
require_relative '../../lib/pesquisa'
require_relative '../../db/db'
require 'stringio'

DB.connect

feature 'Mostra menu ao iniciar aplicação' do
  scenario 'com sucesso' do
    $stdin = StringIO.new('4')
    expect { View.bem_vindo }.to output(a_string_including('Seja bem-vind@ ao sistema de nomes do Brasil')).to_stdout
    expect { View.bem_vindo }.to output(include('Escolha a opção desejada:',
                                                '[1] Ranking dos nomes mais comuns por Unidade Federativa (UF)',
                                                '[2] Ranking dos nomes mais comuns por cidade',
                                                '[3] Frequência do uso de um nome por período',
                                                '[4] Sair')).to_stdout
  end
end

DB.close
