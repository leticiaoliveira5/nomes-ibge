require 'csv'

# transforma arquivo csv em um array de hashes e salva no arquivo parsed_population_data.txt
population_data = File.read('data/populacao_2019.csv')
parsed_population_data = CSV.parse(population_data, headers: true).map(&:to_h)
File.write('data/parsed_population_data', parsed_population_data)
