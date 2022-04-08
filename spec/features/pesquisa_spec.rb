require 'spec_helper'

describe Pesquisa do
  describe '#listar_ufs' do
    it 'deve listar as UFs' do
      VCR.use_cassette('listar_ufs_sucesso') do
        expect { Pesquisa.listar_ufs }.to output(include('Lista das Unidades Federativas',
                                                         'Acre', 'AC',
                                                         'Amazonas', 'AM',
                                                         'Minas Gerais', 'MG',
                                                         'São Paulo', 'SP',
                                                         'Tocantins', 'TO')).to_stdout
      end
    end
  end

  describe '#listar_municipios' do
    context 'quando a UF digitada existe' do
      it 'lista as municipios da UF escolhida' do
        VCR.use_cassette('listar_minicipios_sucesso') do
          expect { Pesquisa.listar_municipios('SE') }.to output(include('Municípios - SE',
                                                                        'Aquidabã',
                                                                        'Areia Branca')).to_stdout
        end
      end
    end

    context 'quando a UF digitada não existe' do
      it 'mostra erro' do
        VCR.use_cassette('listar_municipios_erro') do
          expect do
            Pesquisa.listar_municipios('PS')
          end.to output(a_string_including('Opção Inválida')).to_stdout
        end
      end
    end
  end

  describe '#nomes_por_uf' do
    context 'quando a UF digitada existe' do
      it 'mostra os nomes mais frequentes na UF' do
        VCR.use_cassette('nomes_por_uf_sucesso') do
          expect do
            Pesquisa.nomes_por_uf('AC')
          end.to output(include('Acre - Ranking Nomes - Todos',
                                'RANKING', 'NOME', 'FREQUÊNCIA', 'PERCENTUAL')).to_stdout
        end
      end
    end

    context 'quando a UF digitada não existe' do
      it 'mostra erro' do
        VCR.use_cassette('nomes_por_uf_erro') do
          expect do
            Pesquisa.nomes_por_uf('SS')
          end.to output(a_string_including('Opção Inválida')).to_stdout
        end
      end
    end
  end

  describe '#nomes_por_municipio' do
    context 'quando a pesquisa retorna resultados' do
      it 'mostra nomes mais frequentes no Municipio' do
        VCR.use_cassette('nomes_por_municipio_sucesso') do
          expect do
            Pesquisa.nomes_por_municipio('Duque de Caxias', 'RJ')
          end.to output(include('Duque de Caxias - Ranking Nomes - Todos',
                                '1', 'MARIA',
                                '2', 'JOSE')).to_stdout
        end
      end
    end

    context 'quando a pesquisa não encontra o município' do
      it 'mostra erro' do
        VCR.use_cassette('nomes_por_municipio_erro') do
          expect do
            Pesquisa.nomes_por_municipio('Cabo', 'AM')
          end.to output(a_string_including('Opção Inválida')).to_stdout
        end
      end
    end
  end

  describe '#frequencia_por_periodo' do
    context 'quando a busca retorna resultados' do
      it 'mostra frequência do nome buscado' do
        VCR.use_cassette('frequencia_por_periodo_sucesso') do
          expect do
            Pesquisa.frequencia_por_periodo('mara%7Cmaria')
          end.to output(include('MARA',
                                '1930[', '254',
                                '[1930,1940[', '582',
                                'MARIA',
                                '1930[', '336477',
                                '[1930,1940[', '749053')).to_stdout
        end
      end
    end

    context 'quando a busca não retorna resultados' do
      it 'mostra erro' do
        VCR.use_cassette('frequencia_por_periodo_erro') do
          expect do
            Pesquisa.frequencia_por_periodo('Magaalii')
          end.to output(a_string_including('Opção Inválida')).to_stdout
        end
      end
    end
  end
end
