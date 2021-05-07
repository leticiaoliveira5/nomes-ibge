# frozen_string_literal: true

require 'active_record'

class UnidadeFederativa < ActiveRecord::Base
  has_many :municipios
end
