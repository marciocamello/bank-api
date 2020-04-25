# BankApi

**This is a Stone Challenge, to propose financials logic API**

## Development

Clone project

```
https://gitlab.com/marcio-elixir/bank-api.git
cd bank-api
```

Docker deploy

```
cd docker/dev
docker-compose up -d
```

Install dependencies

```
docker exec -it bank-api mix deps.get
```

Access api

http://localhost:4000

Run Tests

```
docker exec -it bank-api mix test
```

Run Coveralls

```
docker exec -it bank-api bash -c "MIX_ENV=test mix coveralls.html"
access cover/coveralls.html
```
