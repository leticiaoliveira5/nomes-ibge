require 'csv'

class ParseCSV
# transforma arquivo csv em um array de hashes e salva no arquivo parsed_population_data.txt

  def self.call
    population_data = File.read('data/populacao_2019.csv')
    parsed_population_data = CSV.parse(population_data, headers: true).map(&:to_h)
    parsed_population_data
  end
end