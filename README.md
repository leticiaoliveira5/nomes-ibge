## :memo: Nomes Populares do Brasil

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/50ea3cbee57149898453ee6c3a6b4939)](https://app.codacy.com/gh/leticiaoliveira5/nomes-ibge?utm_source=github.com&utm_medium=referral&utm_content=leticiaoliveira5/nomes-ibge&utm_campaign=Badge_Grade_Settings)

Aplicação Ruby para uso no terminal que permite acesso à estatísticas de nomes populares no Brasil, com dados do IBGE.

### :white_check_mark: Funcionalidades

- [x] Ranking dos nomes mais comuns em uma determinada Unidade Federativa (UF)
- [x] Ranking dos nomes mais comuns em uma determinada cidade
- [x] Rankings dos nomes separados por gênero
- [x] Frequência do uso de um nome ao longo dos anos

### 🎲 Rodando o App no Terminal

Antes de começar, você vai precisar estar conectado à internet e ter instalado em sua máquina: 

* [Ruby](https://www.ruby-lang.org/pt/documentation/installation/) versão: 2.7.2

Para instalar o ruby, você pode usar o comando (no Linux):
```bash
sudo apt-get install ruby
```

* Clone este repositório
```bash
git clone <https://github.com/leticiaoliveira5/nomes-ibge>
```
Ou, se não tiver o [Git](https://git-scm.com) instalado, faça o download manualmente.

* Acesse a pasta do projeto no terminal/cmd
```bash
cd nomes-ibge
bundle install
```

* Roda a aplicação no terminal com
```bash
ruby nomes_brasil.rb
```

### :gem: Gems utilizadas

* [Activesupport](https://rubygems.org/gems/activesupport/versions/5.0.0.1?locale=pt-BR) - ferramentas do rails
* [Faraday](https://rubygems.org/gems/faraday?locale=pt-BR) - para lidar com requisições http
* [Rspec](https://rubygems.org/gems/rspec?locale=pt-BR) - para testar o código
* [Terminal-table](https://rubygems.org/gems/terminal-table/) - para criar as tabelas exibidas no terminal
* [VCR](https://rubygems.org/gems/vcr/versions/3.0.1?locale=pt-BR) - para guardar as requests HTTP dos testes

### :satellite: Fontes

* API de Localidades: https://servicodados.ibge.gov.br/api/docs/localidades?versao=1
* API de Nomes: https://servicodados.ibge.gov.br/api/docs/nomes?versao=2
* CSV com dados da população: https://campus-code.s3-sa-east-1.amazonaws.com/treinadev/populacao_2019.csv

### :tada: Developer

  [/leticiaoliveira5](https://github.com/leticiaoliveira5)
