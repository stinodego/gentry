from fastapi.testclient import TestClient

from autopoetry import main

client = TestClient(main.app)


def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"msg": "Hello World"}


def test_get_poem(mocker):
    mocker.patch.object(main, "haiku", return_value={"title": "title"})

    response = client.get("/poems/haiku")

    assert main.haiku.called
    assert response.status_code == 200
    assert response.template.name == "poem.html"
    assert "request" in response.context
    assert response.context["title"] == "title"


def test_get_poem_unknown_type():
    response = client.get("/poems/sonnet")

    assert response.status_code == 404
    assert response.json() == {"detail": "Item not found"}
