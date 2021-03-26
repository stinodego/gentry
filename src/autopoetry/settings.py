from dotenv import find_dotenv
from pydantic import BaseSettings


class Settings(BaseSettings):
    aws_region: str
    dynamodb_table: str

    class Config:
        env_file = find_dotenv()


settings = Settings()
