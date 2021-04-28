# :memo: Nomes Populares do Brasil
Aplicação Ruby para uso no terminal que permite acesso à estatísticas de nomes populares no Brasil, fazendo uso de dados do IBGE.

<h3 align="center"> 
	🚧  Em construção...  🚧
</h3>

### :white_check_mark: Funcionalidades

- [x] Ranking dos nomes mais comuns em uma determinada Unidade Federativa (UF)
- [x] Ranking dos nomes mais comuns em uma determinada cidade
- [x] Rankings dos nomes separados por gênero
- [x] Frequência do uso de um nome ao longo dos anos
- [ ] Carrega dados ao iniciar

### :warning: Pré-requisitos

Antes de começar, você vai precisar ter instalado em sua máquina as seguintes ferramentas: 

- [Ruby](https://www.ruby-lang.org/pt/documentation/installation/) versão: 2.7.2
- [Git](https://git-scm.com) 
- [PostgreSQL](https://www.postgresql.org/)

### 🎲 Rodando o App no Terminal:

```bash
# Clone este repositório
$ git clone <https://github.com/leticiaoliveira5/nomes-ibge>

# Acesse a pasta do projeto no terminal/cmd
$ cd nomes-ibge

# Instale as dependências
$ bundle install

# Rode a aplicação no terminal com:
$ ruby nomes_do_brasil.rb

```

### :gem: Gems utilizadas

- [Faraday](https://rubygems.org/gems/faraday?locale=pt-BR) - para lidar com requisições http
- [Rspec](https://rubygems.org/gems/rspec?locale=pt-BR) - para testar o código
- [Terminal-table](https://rubygems.org/gems/terminal-table/) - para criar as tabelas exibidas no terminal

### :heavy_check_mark: Testando o código
```bash
# Execute o comando
$ rspec
```
### :satellite: Fontes

- API de Localidades: https://servicodados.ibge.gov.br/api/docs/localidades?versao=1
- API de Nomes: https://servicodados.ibge.gov.br/api/docs/nomes?versao=2
- CSV com dados da população: https://campus-code.s3-sa-east-1.amazonaws.com/treinadev/populacao_2019.csv

### :tada: Developer

[/leticiaoliveira5](https://github.com/leticiaoliveira5)