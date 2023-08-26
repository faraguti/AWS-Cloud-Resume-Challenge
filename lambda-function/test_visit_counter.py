import unittest
from unittest.mock import patch
import visit_counter
from colorama import init, Fore

init(autoreset=True)  # Initialize colorama

class TestLambdaFunction(unittest.TestCase):
    @patch('boto3.resource')
    def test_lambda_handler(self, mock_boto3):
        # Mock DynamoDB responses
        mock_response = {
            'Item': {
                'pk': '1',
                'sk': '1',
                'visits': '0'  # Initial value doesn't matter, as it will be replaced
            }
        }
        mock_table = mock_boto3.return_value.Table.return_value
        mock_table.get_item.return_value = mock_response

        # Call the Lambda function to get initial visits value
        initial_visits = visit_counter.lambda_handler({}, {})

        # Call the Lambda function again to simulate adding +1 to visits
        updated_visits = visit_counter.lambda_handler({}, {})

        # Verify the result and interactions
        if int(updated_visits) == int(initial_visits) + 1:
            print(Fore.GREEN + f"🎉 Test Passed: The counter started at {initial_visits} and was updated correctly to {updated_visits}!")
        else:
            print(Fore.RED + f"❌ Test Failed: The counter started at {initial_visits}, but was not updated correctly")


if __name__ == '__main__':
    unittest.main()