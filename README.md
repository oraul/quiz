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

Caso tenha algum erro para salvar as credenciais:

A estrutura a ser seguida é essa:

```yaml
auth_adapter:
  secret_key: 'XXX'

database:
  host: 'db'
  port: 5432
  username: 'postgres'
  password: 'postgres'
```

Acesse o bash:

```sh
docker-compose run --rm app bash

apk add vim

EDITOR=vim rails credentials:edit --environment development
EDITOR=vim rails credentials:edit --environment test
```

Inicialize o banco de dados:

```sh
docker-compose run --rm app bin/setup
```

Inicialize a aplicação:
````sh
docker-compose up
```

Como a api precisa de um token, gere um para o desenvolvimento:
```sh
docker compose run --rm app bin/rails dev:generate_token
```

Acesse o swagger:
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
- Criar uma disciplina primeiro

### /questions

- CRUD das questões em conjunto das alternativas
- Criar um tópico primeiro
- Filtrar a listagem com os parâmetros by_topic_id e by_enunciation_like
- Preencher 5 alternativas e uma precisa ter o correct=true

### /answers

- CRUD das respostas
- Consumir a url da alternativa que está no header location após de criar uma answer, eu abstrai pois mantemos os domínios separados e essa url de alternativa pode ter um cache mais direcionado

### /most_answered/disciplines

- Mostrar as disciplinas mais respondidas nas últimas 24 horas
- A query não é performática por ter muitos relacionamentos, o ideal é consumir de um banco de dados tratado por um time de Data

## Conceitos

### Rest

- Foquei em organizar os domínios de cada endpoint
- O endpoint answer pode ficar dentro do namespace question (Ex: /questions/1/answers) mas eu quero evitar uma requisição extra no banco de dados

### Swagger

- O swagger ajuda a documentar a api do serviço, além de servir como uma interface para fazer requisição

### Clean Archicture

- Eu criei as pastas adapters e entities para organizar os domínios que elas pertencem
- Caso evolua o scope do Discipline.most_answered, pode ser abstraído para um *Use Case*

### Gems

- has_scope: Facilita o controle dos escopos do Model no controller
- rswag: Cria uma documentação do swagger via spec
- shoulda-matchers: Facilita nos testes de models
- rubocop: Analisa códigos fora do padrão da comunidade
- jbuilder: Simplifica a construção do json e usa um padrão para fazer cache fragmentado
- rspec: DSL para o teste

### Listar as disciplinas das últimas 24h

Eu fiz uma query mais simplificada, mas o ideal seria alimentar algum elasticsearch ou metabase e tratar os dados como um "tabelão", aí evita dar vários joins nos relacionamentos do banco de dados.

### Escalar o serviço

Possíveis etapas:

- Escalar horizontalmente replicando o projeto e apontando no load balancer
- Criar shards leitura do banco de dados, o Rails 7 tem suporte a múltiplos bancos de dados: `connects_to database: { writing: :primary, reading: :primary_replica }`
- Adicionar um gateway para controlar o limit rate das requests e controle de cache
