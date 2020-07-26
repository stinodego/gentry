from pathlib import Path
from typing import Any, Dict

from fastapi import FastAPI, HTTPException, Request
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from starlette.templating import Jinja2Templates, _TemplateResponse

from autopoetry.models.poem import haiku

Json = Dict[str, Any]

app = FastAPI()

static_dir = Path(__file__).parent / "static"
app.mount("/static", StaticFiles(directory=str(static_dir)), name="static")

template_dir = Path(__file__).parent / "templates"
templates = Jinja2Templates(directory=str(template_dir))


class Poem(BaseModel):
    title: str
    body: str
    author: str
    source: str


@app.get("/")
def read_root() -> Json:
    return {"msg": "Hello World"}


@app.get("/poems/{poem_type}")
async def get_poem(request: Request, poem_type: str) -> _TemplateResponse:
    if poem_type == "haiku":
        poem = haiku()
    else:
        raise HTTPException(status_code=404, detail="Item not found")

    return templates.TemplateResponse("poem.html", {"request": request, **poem})
