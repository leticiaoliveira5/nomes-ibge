# :memo: Desafios Ruby - Nomes Populares do Brasil
Aplicação Ruby para uso no terminal que permite acesso à estatísticas de nomes populares no Brasil, fazendo uso de dados do IBGE.

<h4 align="center"> 
	🚧  Em construção...  🚧
</h4>

### :white_check_mark: Funcionalidades

- Desafio 1
- [ ] Ranking dos nomes mais comuns em uma determinada Unidade Federativa (UF)
- [ ] Ranking dos nomes mais comuns em uma determinada cidade
- [ ] Frequência do uso de um nome ao longo dos anos

### :warning: Pré-requisitos

Antes de começar, você vai precisar ter instalado em sua máquina as seguintes ferramentas: 

- [Ruby](https://www.ruby-lang.org/pt/documentation/installation/) versão: 2.7.2
- [Git](https://git-scm.com) 
- [SQLite3](https://www.sqlite.org/index.html)

### 🎲 Rodando o App no Terminal:

```bash
# Clone este repositório
$ git clone <https://github.com/leticiaoliveira5/nomes-ibge>

# Acesse a pasta do projeto no terminal/cmd
$ cd nomes-ibge

# Instale as dependências
$ bundle install

# Rode a aplicação no terminal com:
$ ruby lib/nomes.rb

```

### :gem: Gems utilizadas

- [Faraday](https://rubygems.org/gems/faraday?locale=pt-BR)
- [Rspec](https://rubygems.org/gems/rspec?locale=pt-BR)
- [Rake](https://rubygems.org/gems/rake?locale=pt-BR)

### :heavy_check_mark: Testando o código
```bash
# Execute o comando
$ rspec
```
### :satellite: Fontes IBGE

- API de Localidades: https://servicodados.ibge.gov.br/api/docs/localidades?versao=1
- API de Nomes: https://servicodados.ibge.gov.br/api/docs/censos/nomes?versao=2
- CSV com dados da população: https://campus-code.s3-sa-east-1.amazonaws.com/treinadev/populacao_2019.csv

### :tada: Developer

[/leticiaoliveira5](https://github.com/leticiaoliveira5)