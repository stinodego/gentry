import unittest
from unittest.mock import patch

from app.poem import haiku


class TestPoem(unittest.TestCase):

    @patch('app.poem.HAIKUS', ['a', 'b'])
    def test_haiku(self):
        result = haiku()

        self.assertIn(result, ['a', 'b'])
