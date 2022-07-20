# Rebase Challenge 2022  
___
## API em Ruby para listagem de exames médicos, de acordo com o Desafio Rebase 2022.

- Os requisitos do desafio podem ser encontrados [aqui](https://git.campuscode.com.br/core-team/rebase-challenge-2022).

## Tech Stack

* [Docker](https://docs.docker.com/)
* [Ruby](https://www.ruby-lang.org/en/)
## Requisitos
- [Docker](https://docs.docker.com/) instalado em seu computador.
___
## Rodando a aplicação
#### Navegue pelo terminal até a pasta do projeto e execute os seguintes comandos:
```bash
$ docker-compose build
$ docker-compose up
```
#### A aplicação ficará disponível no endereço : ``` localhost:3000 ```
 - Para fornecer as informações ao banco de dados, envie uma requisição ao endpoint /import, conforme o tópico Endpoints - POST /import.
___
## Executando os testes
#### Após ter executado os passos do tópico Rodando a aplicação, em um novo terminal ainda na pasta do projeto, execute os seguintes comandos:
```bash
$ docker exec -it rebase-challenge bash
$ bundle install --with development test
$ rspec
```
- O volume do banco de dados será mapeado para pasta home do sistema.
___
# Endpoints
# GET /tests
#### Retorna todos os dados referentes a pacientes, exames e médicos presentes no banco de dados.
## Exemplo de resposta
___
### - Requisição bem sucedida (201)
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
### - Banco de dados vazio (500)
```json
{
    "message": "The table doesnt exist, please do a import first" 
}
``` 

### - Erro na requisição (500)
```json
{
    "message": "Something went wrong" 
}
``` 

---
# POST /import
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

## Exemplo de resposta 
___
### - Requisição bem sucedida (201)

```json 
{
    "message": "Import has been finished"
}
``` 
### - Erro no body da requisição (500)
```json 
{
    "message": "filename or table_name are missing" 
}
``` 

### - Erro na requisição (500)
```json
{
    "message": "Something went wrong" 
}
``` 
___
# GET /tests/:token
#### Realiza a busca de Paciente, médico e informações de exames através do token informado.
## Exemplo de resposta
___
### -  Requisição bem sucedida (201)

#### - GET /tests/0W9I67
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
        ...
    ]
}
```

### - Falha na requisição - Token inexistente (500)

```json
{
    "message": "We could not find any data with token: 0W9I673"
}
```

### - Erro na requisição (500) 

```json
{
    "message": "Something went wrong"
}
```
____
# DELETE /clean_test_table
#### Remove todas as linhas do banco de dados.

## Exemplo de resposta

### - Requisição bem sucedida (200)

```json
{
   "message" : "table dropped" 
}
```

### - Erro na requisição (500)

```json
{
  "message": "Something went wrong"
}
```