require 'active_record'
require 'csv'
require_relative 'lib/view'

# transforma arquivo csv em um array de hashes e salva no arquivo parsed_population_data.txt
parsed_population_data = CSV.parse(File.read('data/populacao_2019.csv'), headers: true).map(&:to_h)
File.write('data/parsed_population_data', parsed_population_data)

puts '================== A aplicação está pronta ==================='
View.bem_vindo
