import unittest
from unittest.mock import MagicMock, patch
import visit_counter

class TestVisitCounter(unittest.TestCase):
    @patch("visit_counter.boto3.resource")
    def test_lambda_handler(self, mock_resource):
        # Create a mock DynamoDB resource and table
        mock_table = MagicMock()
        mock_resource.return_value.Table.return_value = mock_table

        # Set up mock response for DynamoDB get_item and put_item
        mock_get_item_response = {
            'Item': {'id': '1', 'visits': 76}
        }
        mock_table.get_item.return_value = mock_get_item_response

        mock_put_item_response = {}
        mock_table.put_item.return_value = mock_put_item_response

        # Call the Lambda handler
        result = visit_counter.lambda_handler(None, None)

        # Verify that the DynamoDB methods were called correctly
        mock_table.get_item.assert_called_once_with(Key={'id': '1'})
        mock_table.put_item.assert_called_once_with(Item={'id': '1', 'visits': 77})

        # Verify the result returned by the handler
        self.assertEqual(result, 77)  # Expected updated visit count

if __name__ == '__main__':
    unittest.main()
