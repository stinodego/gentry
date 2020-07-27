import random
import textwrap
from typing import Any, Dict

HAIKUS = [
    {
        "title": "the good place",
        "body": textwrap.dedent(
            """
            what is this good place
            that i keep hearing about
            not even in dreams
            """
        ).strip("\n"),
        "author": "Stijn de Gooijer",
        "source": "Unpublished",
    },
    {
        "title": "the bad place",
        "body": textwrap.dedent(
            """
            an eternity
            suffering and nothingness
            plus one lifetime more
            """
        ).strip("\n"),
        "author": "Stijn de Gooijer",
        "source": "Unpublished",
    },
]


def haiku() -> Dict[str, Any]:
    """Return a random haiku.

    Returns:
        dict: JSON representation of a haiku."""
    return random.choice(HAIKUS)
