require 'terminal-table'

class Tabela
  def self.new(title:, headings:, rows:)
    tabela = Terminal::Table.new title: title, headings: headings, rows: rows
    puts tabela
  end
end
