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
```

Instale um editor preferido:

```
apk add vim
```

Edite a credencial tanto para o development e test:
```
EDITOR=vim rails credentials:edit --environment YOUR_ENVIRONMENT
```

Inicialize o banco de dados:

```sh
docker-compose run --rm app bin/setup
```

Popule o banco de dados:

```sh
docker-compose run --rm app bin/rails db:seed
```

Inicialize a aplicação:
```sh
docker-compose up
```

Como a api precisa de um token, gere um para o desenvolvimento:
```sh
docker compose run --rm app bin/rails dev:generate_token
```

Ele vai gerar um Bearer XXX, copie o XXX para colocar no Authorize do swagger


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

### /health

- Checar se a aplicação está sendo executada, depois apontamentos para algum healthcheck

### /disciplines

- CRUD das disciplinas

### /topics

- Criar uma disciplina primeiro antes de continuar
- CRUD dos assuntos

### /questions

- Criar um tópico primeiro antes de continuar
- CRUD das questões em conjunto das alternativas
- Filtrar a listagem com os parâmetros by_topic_id e by_enunciation_like
- Preencher 5 alternativas e uma precisa ter o correct=true
- Adicionar o id para atualizar a alternativa: `{ "alternatives_attributes": [{ "id": "alternative_id" }]}`

### /answers

- CRUD das respostas
- Consumir a url da alternativa que está no header location após de criar uma answer, eu abstrai pois mantemos os domínios separados e essa url de alternativa pode ter um cache mais direcionado
- O endpoint answer pode ficar dentro do namespace question (Ex: /questions/1/answers) mas eu quero evitar uma requisição extra no banco de dados (tabela questions)
- O usuário consegue responder a mesma questão N vezes, eu acho que é interessante para fazer o tracking quantas vezes ele errou a resposta

### /most_answered/disciplines

- Mostrar as disciplinas mais respondidas nas últimas 24 horas
- A query não é performática por ter muitos relacionamentos, o ideal é consumir de um banco de dados tratado por um time de Data

## Conceitos

### Rest

- Foquei em organizar os domínios de cada endpoint
- Os controllers estão enxutos e o mais semelhante com o Rails Way
- Para facilitar o controle das views, usei o jbuilder e ela é simples em criar views e tem uma camada de cache simplificada

### Swagger

- O swagger ajuda a documentar a api do serviço, além de servir como uma interface para fazer requisição

### Clean Archicture

- Eu criei as pastas adapters e entities para organizar os domínios que elas pertencem
- Caso evolua o scope do Discipline.most_answered, pode ser abstraído para um *Use Case*
- O UserEntity, pode futuramente ter regras para checar se o token expirou e também serve como interface para o tipo de role(Ex: admin?, user?, editor?) que pode usar em conjunto de uma pattern de autorização
- O AuthAdapter, ele pode trocar o tipo de token a ser usado

### Gems

- has_scope: Facilita o controle dos escopos do Model no controller
- rswag: Cria uma documentação do swagger via spec
- shoulda-matchers: Facilita nos testes de models
- rubocop: Analisa códigos fora do padrão da comunidade
- jbuilder: Simplifica a construção do json e usa um padrão para fazer cache fragmentado
- rspec: DSL para o teste
- connection_pool: Configura um pool de conexões para o redis

### Listar as disciplinas das últimas 24h

Eu fiz uma query mais simplificada, mas o ideal é alimentar algum elasticsearch ou metabase e tratar os dados como um "tabelão", aí evita em estressar com vários joins nos relacionamentos do banco de dados.

## Melhorias

- Adicionar paginação
- Apontar o /health na infraestrutura (Ex: no probes do kubernetes )
- Adicionar uma camada de autorização para checar o que o token específico pode fazer
- Configurar para produção a aplicação
- Adicionar conexão com o vault para armazenar os secrets
- Configurar o codeclimate e deixar mais aparente nos PRs
- Configurar o dependabot para automatizar a checagem de atualização das gems
- Adicionar autorização na listagem dos endpoints, onde usuário normal pode ver só as respostas dele e usuário admin pode ver tudo
- Mudar o unique key do Topic para unique key composto [name, discipline_id]
- Escalar horizontalmente replicando o projeto e apontando no load balancer
- Criar shards de leitura do banco de dados, o Rails 7 tem suporte a múltiplos bancos de dados: `connects_to database: { writing: :primary, reading: :primary_replica }`
- Adicionar um gateway para controlar o limit rate das requests e controle de cache
- Adicionar index só quando necessário, pois aumenta o tamanho do banco de dados consideravelmente
- Enviar as respostas para um serviço a parte que compila ela e depois consumir o formato consolidado para filtros como "Disciplinas mais respondidas nas últimas 24h"
- Testar a gem kredis que facilita o uso do redis no ActiveRecord para fazer cache de alguns atributos
- Fazer o tunning de threads
- Adicionar APM como o NewRelic
- Adicionar o Airbrake para checar bugs
- Adicionar o OpenTelemetry para ter o tracing
