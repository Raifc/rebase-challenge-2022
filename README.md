# Rebase Challenge 2022  
___
## API em Ruby para listagem de exames médicos, de acordo com o Desafio Rebase 2022.

- Os requisitos do desafio podem ser encontrados [aqui](https://git.campuscode.com.br/core-team/rebase-challenge-2022).
- Deploy da aplicação feito na AWS, acesse [aqui](http://3.87.194.37:3000/tests).
## Tech Stack

* [Docker](https://docs.docker.com/)
* [Ruby](https://www.ruby-lang.org/en/)
* [Redis](https://redis.io/)
* [PostgreSQL](https://www.postgresql.org/)
## Requisitos
- [Docker](https://docs.docker.com/) instalado em seu computador.
- [Docker Compose](https://docs.docker.com/compose/install/)
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
$ docker-compose build
$ docker-compose up -d
$ docker exec -it rebase-challenge bash
$ bundle install --with development test
$ rspec
```
- O volume do banco de dados será mapeado para pasta home do sistema.
___
# Endpoints
As informações sobre os endpoints podem ser encontradas [aqui](https://github.com/Raifc/rebase-challenge-2022/blob/main/API.md).
