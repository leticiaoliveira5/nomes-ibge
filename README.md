## :memo: Nomes Populares do Brasil
Aplicação Ruby para uso no terminal que permite acesso à estatísticas de nomes populares no Brasil, fazendo uso de dados do IBGE.

### :white_check_mark: Funcionalidades

- [x] Ranking dos nomes mais comuns em uma determinada Unidade Federativa (UF)
- [x] Ranking dos nomes mais comuns em uma determinada cidade
- [x] Rankings dos nomes separados por gênero
- [x] Frequência do uso de um nome ao longo dos anos

### :warning: Pré-requisitos

Antes de começar, você vai precisar estar conectado à internet e ter instalado em sua máquina: 

* [Ruby](https://www.ruby-lang.org/pt/documentation/installation/) versão: 2.7.2

### 🎲 Rodando o App no Terminal

```bash
# Clone este repositório
$ git clone <https://github.com/leticiaoliveira5/nomes-ibge>
Ou, se não tiver o [Git](https://git-scm.com) instalado, faça o download manualmente.

# Acesse a pasta do projeto no terminal/cmd
$ cd nomes-ibge

# Instala dependências e carrega os dados
$ bin/setup

# Rode a aplicação no terminal com
$ ruby nomes_do_brasil.rb

```

### :gem: Gems utilizadas

* [Faraday](https://rubygems.org/gems/faraday?locale=pt-BR) - para lidar com requisições http
* [Rspec](https://rubygems.org/gems/rspec?locale=pt-BR) - para testar o código
* [Terminal-table](https://rubygems.org/gems/terminal-table/) - para criar as tabelas exibidas no terminal
* [Active-Record](https://rubygems.org/gems/activerecord/versions/4.2.6?locale=pt-BR) - para facilitar o acesso aos dados do banco
* [StringIO](https://rubygems.org/gems/stringio/versions/0.0.1) - para simular inputs(gets) durante os testes

### :heavy_check_mark: Testando o código
```bash
# Execute o comando
$ rspec
```
### :satellite: Fontes

* API de Localidades: https://servicodados.ibge.gov.br/api/docs/localidades?versao=1
* API de Nomes: https://servicodados.ibge.gov.br/api/docs/nomes?versao=2
* CSV com dados da população: https://campus-code.s3-sa-east-1.amazonaws.com/treinadev/populacao_2019.csv

### :tada: Developer

  [/leticiaoliveira5](https://github.com/leticiaoliveira5)