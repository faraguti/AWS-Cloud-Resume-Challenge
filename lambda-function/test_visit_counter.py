import importlib
import json
import os
import sys
import unittest
from decimal import Decimal
from unittest.mock import patch

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import visit_counter  # noqa: E402


class TestVisitCounter(unittest.TestCase):
    def setUp(self):
        # Mock boto3 inside the module so no test can reach real AWS.
        visit_counter._table = None
        patcher = patch("visit_counter.boto3")
        self.mock_boto3 = patcher.start()
        self.addCleanup(patcher.stop)
        self.addCleanup(setattr, visit_counter, "_table", None)
        self.table = self.mock_boto3.resource.return_value.Table.return_value

    def test_returns_new_total_as_int(self):
        # DynamoDB returns numbers as Decimal.
        self.table.update_item.return_value = {"Attributes": {"visits": Decimal("42")}}

        result = visit_counter.lambda_handler({}, None)

        self.assertEqual(result, 42)
        self.assertIsInstance(result, int)

    def test_result_is_json_serializable(self):
        self.table.update_item.return_value = {"Attributes": {"visits": Decimal("7")}}

        self.assertEqual(json.dumps(visit_counter.lambda_handler({}, None)), "7")

    def test_increments_atomically_in_one_call(self):
        self.table.update_item.return_value = {"Attributes": {"visits": Decimal("1")}}

        visit_counter.lambda_handler({}, None)

        self.table.update_item.assert_called_once_with(
            Key={"pk": "1", "sk": "1"},
            UpdateExpression="ADD visits :inc",
            ExpressionAttributeValues={":inc": 1},
            ReturnValues="UPDATED_NEW",
        )
        self.table.get_item.assert_not_called()
        self.table.put_item.assert_not_called()

    def test_uses_configured_table(self):
        self.table.update_item.return_value = {"Attributes": {"visits": Decimal("1")}}

        visit_counter.lambda_handler({}, None)

        self.mock_boto3.resource.assert_called_once_with("dynamodb", region_name=visit_counter.REGION)
        self.mock_boto3.resource.return_value.Table.assert_called_once_with(visit_counter.TABLE_NAME)


class TestImportTimeInit(unittest.TestCase):
    """Inside Lambda the table must be built at import (init phase), not per request."""

    def tearDown(self):
        # patch.dict has restored the environment; reload so the module is lazy again.
        importlib.reload(visit_counter)

    def test_builds_table_at_import_inside_lambda(self):
        with patch.dict(os.environ, {"AWS_LAMBDA_FUNCTION_NAME": "cloud-resume-function"}), \
                patch("boto3.resource") as mock_resource:
            importlib.reload(visit_counter)
            mock_resource.assert_called_once()
            self.assertIs(visit_counter._table, mock_resource.return_value.Table.return_value)

    def test_stays_lazy_outside_lambda(self):
        with patch.dict(os.environ, {}, clear=False), patch("boto3.resource") as mock_resource:
            os.environ.pop("AWS_LAMBDA_FUNCTION_NAME", None)
            importlib.reload(visit_counter)
            mock_resource.assert_not_called()
            self.assertIsNone(visit_counter._table)


if __name__ == "__main__":
    unittest.main()
