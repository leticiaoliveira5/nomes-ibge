# frozen_string_literal: true

require 'active_record'

class Municipio < ActiveRecord::Base
  belongs_to :unidade_federativa
end
