# autopoetry

_"Poetry is elementary"_

This is a simple application that pulls up a random poem from a DynamoDB table.

In later iterations, the app will generate poetry automatically.

## Setup

### Environment

This project uses [poetry](https://python-poetry.org/) for dependency management. Install dependencies by running:

```bash
poetry install
```

### Secrets

Since the application depends on a DynamoDB table in AWS, you will need to supply the credentials to access it. Create a `.env` file in the following format:
```
AWS_ACCESS_KEY_ID=***
AWS_SECRET_ACCESS_KEY=***
AWS_REGION=***
DYNAMODB_TABLE=***
```

## References

Insert relevant docs
