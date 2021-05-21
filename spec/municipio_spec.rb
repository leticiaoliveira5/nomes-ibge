require 'spec_helper'
require_relative '../db/db'

DB.connect

describe Municipio do
  context 'Validation' do
    it 'fields cannot be blank' do
      municipio = Municipio.create(nome: '', sigla_uf: '', codigo: '', populacao: '')
      expect(municipio.errors.count).to eq 5
      expect(municipio.errors.full_messages.all? { |message| message.include? "can't be blank" }).to eq true
    end
  end
end

DB.close
