require 'spec_helper'

describe View do
  context '#bem_vindo' do
    it 'mostra menu ao iniciar aplicação' do
      $stdin = StringIO.new('4')
      expect do
        View.bem_vindo
      end.to output(include('Seja bem-vind@ ao sistema de nomes do Brasil',
                            'Escolha a opção desejada:',
                            '[1] Ranking dos nomes mais comuns por Unidade Federativa (UF)',
                            '[2] Ranking dos nomes mais comuns por cidade',
                            '[3] Frequência do uso de um nome por período',
                            '[4] Sair')).to_stdout
    end
  end

  context '#escolher_UF' do
    it 'usuário escolher uma UF' do
      $stdin = StringIO.new('AC')

      expect { View.escolher_uf }.to output(include('Lista das Unidades Federativas',
                                                    'Acre', 'AC',
                                                    'Amazonas', 'AM',
                                                    'São Paulo', 'SP',
                                                    'Minas Gerais', 'MG',
                                                    'Tocantins', 'TO',
                                                    'Digite a sigla da UF desejada: ')).to_stdout
    end
  end
end
