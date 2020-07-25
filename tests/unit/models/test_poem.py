from gentry.models import poem


def test_haiku(mocker):
    mocker.patch.object(poem, "HAIKUS", "haikus")
    mocker.patch.object(poem.random, "choice", return_value="haiku")

    result = poem.haiku()

    poem.random.choice.assert_called_once_with("haikus")
    assert result == "haiku"
