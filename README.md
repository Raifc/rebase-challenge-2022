 Rebase Challenge 2022  

#<p align="center"> API em Ruby para listagem de exames médicos. 

## Aplicação feita de acordo com o Desafio Rebase 2022 
- Os requisitos do desafio podem ser encontrados [aqui](https://git.campuscode.com.br/core-team/rebase-challenge-2022).

## Tech Stack

* [Docker](https://docs.docker.com/)
* [Ruby](https://www.ruby-lang.org/en/)

##Requisitos
- [Docker](https://docs.docker.com/) instalado em seu computador.

## Rodando a aplicação
#### Navegue pelo terminal até a pasta do projeto.

#### No terminal, execute os seguintes comandos:
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

####A aplicação ficará disponível no endereço : ``` localhost:3000 ```

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
## Exemplo de resposta
___
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

### Exemplo de requisição

#### Body da requisição 
```json 
{
    "filename" : "data.csv",
    "table_name" : "tests"
}
```

## Exemplo de resposta 
___
### Requisição bem sucedida (201)

```json 
{
    "message": "Import has been finished"
}
``` 
### Erro no body da requisição (500)
```json 
{
    { "message": "filename or table_name are missing" }
}
``` 

### Erro na requisição (500)
```json
{
    "message": "Something went wrong" 
}
``` 

## GET /tests/:token

## Exemplo de resposta
___
### Requisição bem sucedida (201)

#### GET /tests/0W9I67
```json 
{
    "token_resultado_exame": "0W9I67",
    "data_exame": "2021-07-09",
    "cpf": "048.108.026-04",
    "nome_paciente": "Juliana dos Reis Filho",
    "email_paciente": "mariana_crist@kutch-torp.com",
    "data_nascimento_paciente": "1995-07-03",
    "Médico": {
        "nome_medico": "Maria Helena Ramalho",
        "crm_medico": "B0002IQM66",
        "crm_medico_estado": "SC"
    },
    "Exames": [
        {
            "tipo_exame": "hemácias",
            "limites_tipo_exame": "45-52",
            "resultado_tipo_exame": "28"
        },
        {
            "tipo_exame": "leucócitos",
            "limites_tipo_exame": "9-61",
            "resultado_tipo_exame": "91"
        },
        {
            "tipo_exame": "plaquetas",
            "limites_tipo_exame": "11-93",
            "resultado_tipo_exame": "18"
        },
        {
            "tipo_exame": "hdl",
            "limites_tipo_exame": "19-75",
            "resultado_tipo_exame": "74"
        },
        {
            "tipo_exame": "ldl",
            "limites_tipo_exame": "45-54",
            "resultado_tipo_exame": "66"
        },
        {
            "tipo_exame": "vldl",
            "limites_tipo_exame": "48-72",
            "resultado_tipo_exame": "41"
        },
        {
            "tipo_exame": "glicemia",
            "limites_tipo_exame": "25-83",
            "resultado_tipo_exame": "6"
        },
        {
            "tipo_exame": "tgo",
            "limites_tipo_exame": "50-84",
            "resultado_tipo_exame": "32"
        },
        {
            "tipo_exame": "tgp",
            "limites_tipo_exame": "38-63",
            "resultado_tipo_exame": "16"
        },
        {
            "tipo_exame": "eletrólitos",
            "limites_tipo_exame": "2-68",
            "resultado_tipo_exame": "61"
        },
        {
            "tipo_exame": "tsh",
            "limites_tipo_exame": "25-80",
            "resultado_tipo_exame": "13"
        },
        {
            "tipo_exame": "t4-livre",
            "limites_tipo_exame": "34-60",
            "resultado_tipo_exame": "9"
        },
        {
            "tipo_exame": "ácido úrico",
            "limites_tipo_exame": "15-61",
            "resultado_tipo_exame": "78"
        }
    ]
}
```

### Falha na requisição - Token inexistente (500)

```json
{
    "message": "We could not find any data with token: 0W9I673"
}
```

### Erro na requisição (500) 

```json
{
    "message": "Something went wrong"
}
```