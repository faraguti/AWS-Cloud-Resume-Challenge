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


if __name__ == "__main__":
    unittest.main()
