require 'active_record'
require 'csv'

# transforma arquivo csv em um array de hashes e salva no arquivo parsed_population_data.txt
parsed_population_data = CSV.parse(File.read('data/populacao_2019.csv'), headers: true).map(&:to_h)
File.write('data/parsed_population_data.txt', parsed_population_data)
