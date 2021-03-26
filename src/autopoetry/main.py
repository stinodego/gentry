from pathlib import Path

import uvicorn
from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from starlette.templating import Jinja2Templates, _TemplateResponse

from autopoetry.models.poem import PoemReader

app = FastAPI()

static_dir = Path(__file__).parent / "static"
app.mount("/static", StaticFiles(directory=str(static_dir)), name="static")

template_dir = Path(__file__).parent / "templates"
templates = Jinja2Templates(directory=str(template_dir))


poem_reader = PoemReader()


@app.get("/")
async def random_poem(request: Request) -> _TemplateResponse:
    poem = poem_reader.get_poem()
    return templates.TemplateResponse("poem.html", {"request": request, **poem})


if __name__ == "__main__":
    uvicorn.run(
        "autopoetry.main:app", host="0.0.0.0", port=8000, log_level="debug", reload=True
    )
