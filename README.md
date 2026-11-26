# AWS Cloud Resume Challenge - Faraguti

This repository contains the code and resources for my personal AWS Cloud Resume Challenge. The Cloud Resume Challenge is a fun and hands-on way to demonstrate your AWS skills by building and deploying a serverless web application.

## Table of Contents

- [About the Challenge](#about-the-challenge)
- [Architecture](#architecture)
- [Services Used](#services-used)
- [Repository Structure](#repository-structure)
- [Running the Tests](#running-the-tests)
- [Resources and Documentation](#resources-and-documentation)
- [Contributing](#contributing)

## About the Challenge

**Official Website**: [The Cloud Resume Challenge](https://cloudresumechallenge.dev/)

**Resume Website**: [faraguti.com](https://faraguti.com)

## Architecture

![cloud-resume-challenge](https://github.com/faraguti/AWS-Cloud-Resume-Challenge/assets/5418256/5674900e-c499-4223-be20-fd219b8ed815)

## Services Used

- S3
- CloudFront
- Certificate Manager
- Route 53
- DynamoDB
- Lambda
- API Gateway
- Github Actions
- Terraform

## Repository Structure

- `lambda-function/`: Contains the Python code for the AWS Lambda function.
- `terraform/`: Terraform for the backend (DynamoDB, Lambda, API Gateway). The S3, CloudFront, Certificate Manager and Route 53 hosting is managed outside this repository.
- `website/`: Contains the HTML, CSS, and JavaScript files for the Cloud Resume website.
- `README.md`: Detailed information about the project, setup, and usage.
- `.github/workflows/`: CI/CD. Backend changes are tested and validated on every pull request and deployed with Terraform on merge to `main`; website changes are synced to S3, and the CloudFront cache is invalidated when the `AWS_CLOUDFRONT_DISTRIBUTION_ID` secret is set.

## Running the Tests

The Lambda tests mock AWS, so they need no credentials:

```bash
pip install -r requirements.txt
python -m unittest discover -s lambda-function -v
```

## Resources and Documentation

- [AWS Cloud Resume Challenge](https://cloudresumechallenge.dev/)
- [AWS Lambda Documentation](https://aws.amazon.com/lambda/)
- [Amazon API Gateway Documentation](https://aws.amazon.com/api-gateway/)
- [Amazon DynamoDB Documentation](https://aws.amazon.com/dynamodb/)
- [Amazon S3 Documentation](https://aws.amazon.com/s3/)
- [Amazon CloudFront Documentation](https://aws.amazon.com/cloudfront/)
- [AWS Certificate Manager Documentation](https://aws.amazon.com/certificate-manager/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Terraform Documentation](https://www.terraform.io/docs/index.html)

## Contributing

Contributions are welcome! If you find any issues or have improvements to suggest, feel free to open a GitHub issue or submit a pull request.

---

Feel free to explore the code, deploy the project, and take a look at how the Cloud Resume Challenge was completed! If you have any questions or feedback, don't hesitate to reach out. Enjoy the journey of learning and building with AWS!
