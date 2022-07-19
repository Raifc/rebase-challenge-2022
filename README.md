# Rebase Challenge 2022  

## API em Ruby para listagem de exames médicos, de acordo com o Desafio Rebase 2022.

- Os requisitos do desafio podem ser encontrados [aqui](https://git.campuscode.com.br/core-team/rebase-challenge-2022).

## Tech Stack

* [Docker](https://docs.docker.com/)
* [Ruby](https://www.ruby-lang.org/en/)
## Requisitos
- [Docker](https://docs.docker.com/) instalado em seu computador.

## Rodando a aplicação
#### Navegue pelo terminal até a pasta do projeto, no terminal, execute os seguintes comandos:
```bash
$ docker-compose build
$ docker-compose up
```
#### Em um segundo terminal, execute os seguintes comandos:
```bash
$ docker exec -it rebase-challenge bash
$ RACK_ENV=development bundle exec rackup -s puma -o '0.0.0.0' -p 3000
```

#### Em um terceiro terminal, execute os seguintes comandos:
```bash
$ docker exec -it rebase-challenge bash
$ scripts/start_sidekiq
```

#### A aplicação ficará disponível no endereço : ``` localhost:3000 ```

## Executando os testes
#### Após ter executado os passos do tópico Rodando a aplicação, em um novo terminal, execute os seguintes comandos:
```bash
$ docker exec -it rebase-challenge bash
$ bundle install
$ rspec
```

O volume do banco de dados será mapeado para pasta home do sistema.

Caso durante a execução ocorra algum problema, use o comando abaixo e repita os passos do tópico Rodando a aplicação: 

``` docker container rm -f rebase-challenge-db && docker network prune ```

# Endpoints
## GET /tests
#### Retorna todos os dados referentes aos pacientes, exames e médicos presentes no banco de dados. 
### Exemplo de resposta
#### Headers

```json
      {
      "Content-Length": "1031",
      "X-Content-Type-Options": "nosniff",
      "Content-Type": "application/json"
      }
```
#### Body
```json
[
  {
    "cpf": "048.973.170-88",
    "nome_paciente": "Emilly Batista Neto",
    "email_paciente": "gerald.crona@ebert-quigley.com",
    "data_nascimento_paciente": "2001-03-11",
    "endereco_paciente": "165 Rua Rafaela",
    "cidade_paciente": "Ituverava",
    "estado_patiente": "Alagoas",
    "crm_medico": "B000BJ20J4",
    "crm_medico_estado": "PI",
    "nome_medico": "Maria Luiza Pires",
    "email_medico": "denna@wisozk.biz",
    "token_resultado_exame": "IQCZ17",
    "data_exame": "2021-08-05",
    "tipo_exame": "leucócitos",
    "limites_tipo_exame": "9-61",
    "resultado_tipo_exame": "89"
  },
        ...
] 
```

## POST /import
#### Realiza a importação dos dados do arquivo csv especificado no body da requisição.
___
### Exemplo de requisição

#### Body da requisição 
```json 
{
    "filename" : "data.csv",
    "table_name" : "tests"
}
```

### Exemplo de resposta 

#### Requisição bem sucedida (200)

```json 
{
    "message": "Import has been finished"
}
``` 
#### Erro no body da requisição (500)
```json 
{
    { "message": "filename or table_name are missing" }
}
``` 

#### Erro na requisição (500)
```json
{
    "message": "Something went wrong" 
}
``` 
