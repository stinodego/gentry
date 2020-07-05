from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from pydantic import BaseModel

from src.app.poem import haiku


app = FastAPI()


app.mount("/static", StaticFiles(directory="src/api/static"), name="static")

templates = Jinja2Templates(directory="src/api/templates")


class Poem(BaseModel):
    title: str
    body: str
    author: str
    source: str


@app.get('/')
def read_root():
    return {'Hello': 'World'}


@app.get("/poems/{poem_type}")
async def get_poem(request: Request, poem_type: str):
    if poem_type == 'haiku':
        poem = haiku()
    else:
        return {'Not': 'Found'}
    return templates.TemplateResponse(
        "poem.html", {"request": request, **poem})
