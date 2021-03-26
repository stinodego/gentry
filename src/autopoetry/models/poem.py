from __future__ import annotations

import random

import boto3

from autopoetry.settings import settings

Table = "boto3.resources.factory.dynamodb.Table"


class PoemReader:
    """Read poems from a DynamoDB table."""

    def __init__(self):
        self.table = self._create_table(settings.aws_region, settings.dynamodb_table)
        self.poem_ids = self._get_all_poem_ids(self.table)

    def _create_table(self, aws_region: str, table_name: str) -> Table:
        """Create DynamoDB table object."""
        dynamodb = boto3.resource("dynamodb", region_name=aws_region)
        table = dynamodb.Table(table_name)
        return table

    def _get_all_poem_ids(self, table: Table) -> list[int]:
        """Get all poem IDs from the table."""
        response = table.scan(ProjectionExpression="id")
        all_ids = [int(item["id"]) for item in response["Items"]]
        return all_ids

    def get_poem(self) -> dict[str, str]:
        """Return a random poem from the database.

        Returns:
            dict: JSON representation of a poem."""
        poem_id = random.choice(self.poem_ids)
        return self._read_poem_from_table(poem_id, self.table)

    def _read_poem_from_table(self, id: int, table: Table) -> dict[str, str]:
        """Read the poem with the given ID from the table."""
        poem = table.get_item(Key={"id": id})["Item"]
        poem["source"] = "The Poetry Foundation"
        del poem["id"]
        return poem
