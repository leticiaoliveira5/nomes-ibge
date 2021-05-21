require 'spec_helper'
require_relative '../db/db'

DB.connect

describe UnidadeFederativa do
  context 'Validation' do
    it 'fields cannot be blank' do
      uf = UnidadeFederativa.create(nome: '', sigla: '', codigo: '', populacao: '')
      expect(uf.errors.count).to eq 4
      expect(uf.errors.full_messages.all? { |message| message.include? "can't be blank" }).to eq true
    end
  end
end

DB.close
