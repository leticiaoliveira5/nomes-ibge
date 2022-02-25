require 'spec_helper'
require_relative '../../lib/view'
require_relative '../../lib/pesquisa'

describe Pesquisa do
  describe '#listar_ufs' do
    it 'deve listar as UFs' do
      expect { Pesquisa.listar_ufs }.to output(include('Lista das Unidades Federativas',
                                                       'Acre', 'AC',
                                                       'Amazonas', 'AM',
                                                       'Minas Gerais', 'MG',
                                                       'São Paulo', 'SP',
                                                       'Tocantins', 'TO')).to_stdout
    end
  end

  describe '#listar_municipios' do
    context 'quando a UF digitada existe' do
      it 'lista as municipios da UF escolhida' do
        expect { Pesquisa.listar_municipios('SE') }.to output(include('Municípios - SE',
                                                                      'Aquidabã',
                                                                      'Areia Branca')).to_stdout
      end
    end

    context 'quando a UF digitada não existe' do
      it 'mostra erro' do
        expect { Pesquisa.listar_municipios('PS') }.to output(a_string_including('Opção Inválida')).to_stdout
        expect { Pesquisa.listar_municipios('PS') }.not_to output(include('Municipios- PS')).to_stdout
      end
    end
  end

  describe '#nomes_por_uf' do
    context 'quando a UF digitada existe' do
      it 'mostra os nomes mais frequentes na UF' do
        json = File.read('spec/support/ranking_nomes_acre.json')
        resp_double = double('faraday_resp', status: 200, body: json)
        allow(Faraday).to receive(:get).and_return(resp_double)
        expect { Pesquisa.nomes_por_uf('AC') }.to output(include('Nomes mais frequentes - Acre',
                                                                 'RANKING', 'NOME', 'FREQUÊNCIA', 'PERCENTUAL')).to_stdout
      end
    end

    context 'quando a UF digitada não existe' do
      it 'mostra erro' do
        resp_double = double('faraday_resp', status: 400, body: '')
        allow(Faraday).to receive(:get).and_return(resp_double)
        expect { Pesquisa.nomes_por_uf('SS') }.to output(a_string_including('Opção Inválida')).to_stdout
      end
    end
  end

  describe '#nomes_por_municipio' do
    context 'quando a pesquisa retorna resultados' do
      it 'mostra nomes mais frequentes no Municipio' do
        json = File.read('spec/support/ranking_nomes_caxias.json')
        resp_double = double('faraday_resp', status: 200, body: json)
        allow(Faraday).to receive(:get).and_return(resp_double)
        expect do
          Pesquisa.nomes_por_municipio('Duque de Caxias', 'RJ')
        end.to output(include('Nomes mais frequentes - Duque de Caxias',
                              '1', 'MARIA',
                              '2', 'JOSE')).to_stdout
      end
    end

    context 'quando a pesquisa não encontra o município' do
      it 'mostra erro' do
        resp_double = double('faraday_resp', status: 400, body: '')
        allow(Faraday).to receive(:get).and_return(resp_double)

        expect do
          Pesquisa.nomes_por_municipio('Cabo', 'AM')
        end.to output(a_string_including('Opção Inválida')).to_stdout
      end
    end
  end

  describe '#frequencia_por_periodo' do
    context 'quando a busca retorna resultados' do
      it 'mostra frequência do nome buscado' do
        json = File.read('spec/support/mara_maria.json')
        resp_double = double('faraday_resp', status: 200, body: json)
        allow(Faraday).to receive(:get).and_return(resp_double)
        expect { Pesquisa.frequencia_por_periodo('Mara,Maria') }.to output(include('MARA',
                                                                                   '1930[', '254',
                                                                                   '[1930,1940[', '582',
                                                                                   'MARIA',
                                                                                   '1930[', '336477',
                                                                                   '[1930,1940[', '749053')).to_stdout
      end
    end

    context 'quando a busca não retorna resultados' do
      it 'mostra erro caso a busca não retorne resultado' do
        allow(Faraday).to receive(:gets).and_return([])
        expect do
          Pesquisa.frequencia_por_periodo('Magaalii')
        end.to output(a_string_including('Opção Inválida')).to_stdout
      end
    end
  end
end
