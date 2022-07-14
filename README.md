# Rebase Challenge 2022

## API em Ruby para listagem de exames médicos.

### Aplicação feita de acordo com o Desafio Rebase 2022
Os requisitos do desafio podem ser encontrados em: https://git.campuscode.com.br/core-team/rebase-challenge-2022

## Tech Stack

* Docker
* Ruby
# Desafio 1
## Requisitos
Docker instalado em seu computador: https://docs.docker.com/

## Executando os testes

```bash
$ bin/run_tests
```
## Rodando a aplicação
```bash
$ bin/populate
$ bash run
```
O volume do banco de dados será mapeado para pasta home do sistema, para alterar o local, edite o arquivo bin/populate.

Caso durante a execução ocorra algum problema, use o comando abaixo e repita os passos do tópico Rodando a aplicação: 
``` docker container rm -f rebase-challenge-db && docker network prune ```

# Endpoint
## GET /tests
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

