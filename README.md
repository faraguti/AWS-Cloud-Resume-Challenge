# AWS Cloud Resume Challenge - Faraguti

This repository contains the code and resources for my personal AWS Cloud Resume Challenge. The Cloud Resume Challenge is a fun and hands-on way to demonstrate your AWS skills by building and deploying a serverless web application. I am still working on it!

## Table of Contents

- [About the Challenge](#about-the-challenge)
- [Architecture](#architecture)
- [Features](#features)
- [Getting Started](#getting-started)
- [Repository Structure](#repository-structure)
- [Deployment Steps](#deployment-steps)
- [Resources and Documentation](#resources-and-documentation)
- [Contributing](#contributing)
- [License](#license)

## About the Challenge

**Official Website**: [The Cloud Resume Challenge](https://cloudresumechallenge.dev/)

**Resume Website**: [resume.faraguti.cloud](https://resume.faraguti.cloud)

## Architecture

![cloud-resume-challenge](https://github.com/faraguti/AWS-Cloud-Resume-Challenge/assets/5418256/d0a333c9-6fd3-46a1-8ca8-6908afe7a6d9)


## Features

- Serverless architecture using AWS Lambda and API Gateway.
- Data storage and retrieval using Amazon DynamoDB.
- CORS configuration for cross-origin requests.
- CloudWatch Logs for monitoring and debugging.
- AWS Identity and Access Management (IAM) roles for secure permissions.

## Getting Started

To get started with the Cloud Resume Challenge:

1. Clone this repository to your local machine.
2. Review and deploy the Terraform configuration to create the necessary AWS resources.
3. Deploy the serverless application using the provided Python Lambda function and API Gateway configuration.
4. Access the deployed application URL to interact with the visit counter.

## Repository Structure

- `terraform/`: Contains Terraform configuration files for provisioning AWS resources.
- `lambda/`: Contains the Python code for the AWS Lambda function.
- `README.md`: Detailed information about the project, setup, and usage.

## Deployment Steps

1. Update the Terraform configuration in the `terraform/` directory to match your environment and preferences.
2. Deploy the Terraform stack to create AWS resources.
3. Deploy the Lambda function and API Gateway using the provided configuration and code.
4. Access the application URL to view and interact with the visit counter.

## Resources and Documentation

- [AWS Cloud Resume Challenge](https://cloudresumechallenge.dev/)
- [AWS Lambda Documentation](https://aws.amazon.com/lambda/)
- [Amazon API Gateway Documentation](https://aws.amazon.com/api-gateway/)
- [Amazon DynamoDB Documentation](https://aws.amazon.com/dynamodb/)

## Contributing

Contributions are welcome! If you find any issues or have improvements to suggest, feel free to open a GitHub issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

---

Feel free to explore the code, deploy the project, and take a look at how the Cloud Resume Challenge was completed! If you have any questions or feedback, don't hesitate to reach out. Enjoy the journey of learning and building with AWS!
