# Quiz

## Stack

- Docker
- Docker Compose
- Ruby 3.2.2
- RSpec
- FactoryBot
- Github Actions

## Escopo

- [x] API deverá requisitar um token de acesso
- [x] Listar questões possibilitando o filtro por assunto
- [x] Buscar uma questão específica
- [x] Criar uma nova questão
- [x] Resolver uma questão
- [x] Listar as disciplinas onde as questões foram mais respondidas nas últimas 24hrs

## Execução

Crie as chaves de desenvolvimento e de teste:

```sh
echo 'ce2d296a8b7cd61f694cc1d9bd40fb2f' >> config/credentials/development.key
echo '0898d4538c049d48906f4de4a921cc6c' >> config/credentials/test.key
```

Inicialize a aplicação:

```sh
docker-compose up
```

Como a api precisa de um token, gere um para o desenvolvimento:
```sh
docker compose run --rm app bin/rails dev:generate_token
```

Depois acesse o swagger:
```
http://localhost:3000/api-docs
```

## Testes

Você pode executar o testes localmente:

```
docker-compose run --rm app bin/ci.sh
```

## Endpoints

### /disciplines

- CRUD das disciplinas

### /topics

- CRUD dos assuntos
- Crie uma disciplina primeiro

### /questions

- CRUD das questões em conjunto das alternativas
- Crie um tópico primeiro
- Filtre a listagem com os parâmetros by_topic_id e by_enunciation_like

### /answers

- CRUD das respostas
- Após criar a resposta, tem descrito no header location a url da alternativa

### /most_answered/disciplines

- Mostra as disciplinas mais respondidas nas últimas 24 horas
