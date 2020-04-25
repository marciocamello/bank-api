# BankApi

This is a Stone Challenge, to propose financials logic API

## Development

Clone project

```shell script
https://gitlab.com/marcio-elixir/bank-api.git
cd bank-api
```

Docker deploy

```shell script
cd docker/dev
docker volume create bank_data
docker-compose up -d
```

Migrate Database

```shell script
docker exec -it bank-api mix ecto.create
```

Install dependencies

```shell script
docker exec -it bank-api mix deps.get
```

Run Tests

```shell script
docker exec -it bank-api mix test
```

Run Coveralls

```shell script
docker exec -it bank-api bash -c "MIX_ENV=test mix coveralls.html"
access cover/coveralls.html
```

## Production

## API Tools

Swagger

Insomnia

```shell script
cd rest-tools/swagger
npm i or yarn
access http://localhost:8080/docs
```

Import this file in insomnia

```shell script
rest-tools/insomnia.json
```

Postman

Import this file in postman

```shell script
rest-tools/postman.json
```

API Docs

```json

```

## Deploy

Heroku

Login Account

First Push

Create App

Create PostgreSQL instance

Migrate database

```shell script
heroku run "POOL_SIZE=2 mix ecto.migrate"
```

Push project

