require 'spec_helper'
require 'names_app'

describe 'Names App' do
  it 'deve mostrar a mensagem de bem-vindo' do
    expect{bem_vindo}.to output(a_string_including('Seja bem-vindo ao sistema de nomes do Brasil')).to_stdout
  end
end