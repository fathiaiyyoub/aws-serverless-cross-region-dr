# Serverless Cross-Region Disaster Recovery on AWS

## Project Overview

This project demonstrates how to build a highly available, serverless application across multiple AWS Regions using a disaster recovery (DR) architecture. The solution deploys identical serverless stacks in Sydney (`ap-southeast-2`) and Singapore (`ap-southeast-1`), with Amazon Route 53 automatically directing traffic to the healthy region.

The application exposes REST APIs through Amazon API Gateway, processes requests with AWS Lambda, stores application data in Amazon DynamoDB, and uses AWS Certificate Manager (ACM) to secure a custom domain with HTTPS. Route 53 health checks continuously monitor the primary endpoint and automatically fail over to the secondary Region if the primary becomes unavailable.

This project demonstrates the implementation of a serverless disaster recovery solution using managed AWS services without the need to provision or manage servers.

## Objectives

- Design a highly available serverless application spanning multiple AWS Regions.
- Implement disaster recovery using Amazon Route 53 failover routing and health checks.
- Deploy REST APIs using Amazon API Gateway and AWS Lambda.
- Store application data in Amazon DynamoDB.
- Secure API endpoints with HTTPS using AWS Certificate Manager (ACM) and a custom domain.
- Validate automatic failover between the primary and secondary AWS Regions.
- Gain hands-on experience designing resilient cloud architectures using managed AWS services.

## Architecture

The solution deploys identical serverless application stacks in two AWS Regions:

- **Primary Region:** Asia Pacific (Sydney) – `ap-southeast-2`
- **Secondary Region:** Asia Pacific (Singapore) – `ap-southeast-1`

Amazon Route 53 provides DNS failover by continuously monitoring the health of the primary API endpoint. Under normal operation, client requests are routed to the primary Region. If the primary endpoint becomes unavailable, Route 53 automatically redirects traffic to the secondary Region, allowing the application to remain accessible with minimal disruption.

<p align="center">
  <img src="screenshots/architecture.png" alt="Serverless Cross-Region Disaster Recovery Architecture" width="900">
</p>

## AWS Services Used

| Service | Purpose |
|---------|---------|
| Amazon Route 53 | DNS failover routing and health checks |
| Amazon API Gateway | Exposes REST API endpoints |
| AWS Lambda | Executes the application logic |
| Amazon DynamoDB | Stores application data |
| AWS Identity and Access Management (IAM) | Provides the execution role and permissions for the Lambda functions |
| AWS Certificate Manager (ACM) | Issues SSL/TLS certificates for the custom domain |

## Implementation

The solution was implemented in the following stages:

1. Created a DynamoDB table in both AWS Regions to store application data.
2. Developed separate AWS Lambda functions to handle read and write operations.
3. Configured Amazon API Gateway to expose REST endpoints for the Lambda functions.
4. Requested and validated ACM certificates for a custom API domain.
5. Configured custom domain names and API mappings in both Regions.
6. Created Amazon Route 53 failover records and health checks to monitor the primary API endpoint.
7. Tested the application by performing read and write operations through the custom domain.
8. Simulated a regional failure and verified automatic traffic failover to the secondary Region.

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/read` | Retrieves all items from the DynamoDB table. |
| POST | `/write` | Stores a new item in the DynamoDB table. |

Both endpoints are published through Amazon API Gateway and accessed securely using a custom HTTPS domain.

## Testing and Validation

The solution was validated through the following tests:

- Verified successful data retrieval using the `GET /read` endpoint.
- Verified successful data insertion using the `POST /write` endpoint.
- Confirmed HTTPS connectivity through the custom domain.
- Verified Route 53 health checks correctly monitored the primary API endpoint.
- Simulated a failure in the primary Region and confirmed automatic DNS failover to the secondary Region.
- Confirmed application availability after failover without requiring changes on the client side.


## Screenshots

The following screenshots document the main configuration stages and the successful cross-Region failover test.

| # | Description | Screenshot |
|---|-------------|------------|
| 1 | DynamoDB table created | ![](screenshots/Screenshot%20%2301%20%E2%80%93%20DynamoDB%20Table%20Created.png) |
| 2 | DynamoDB Global Table replica created | ![](screenshots/Screenshot%20%2302%20%E2%80%93%20Global%20Table%20Replica%20Created.png) |
| 3 | IAM role for Lambda created | ![](screenshots/Screenshot%20%2303%20%E2%80%93%20LambdaDynamoDBRole%20Created.png) |
| 4 | Read Lambda function created in Sydney | ![](screenshots/Screenshot%20%2304%20%E2%80%93%20ReadFunction%20Created%20%28Sydney%29.png) |
| 5 | Write Lambda function created in Sydney | ![](screenshots/Screenshot%20%2305%20%E2%80%93%20WriteFunction%20Created%20%28Sydney%29.png) |
| 6 | Read Lambda function created in Singapore | ![](screenshots/Screenshot%20%2306%20%E2%80%93%20ReadFunction%20Created%20%28Singapore%29.png) |
| 7 | Write Lambda function created in Singapore | ![](screenshots/Screenshot%20%2307%20%E2%80%93%20WriteFunction%20Created%20%28Singapore%29.png) |
| 8 | API Gateway REST API created in Sydney | ![](screenshots/Screenshot%20%2308%20%E2%80%93%20HighAvailabilityAPI%20Created%20%28Sydney%29.png) |
| 9 | API Gateway REST API created in Singapore | ![](screenshots/Screenshot%20%2309%20%E2%80%93%20HighAvailabilityAPI%20Created%20%28Singapore%29.png) |
| 10 | `/read` and `/write` resources created in Sydney | ![](screenshots/Screenshot%20%2310%20%E2%80%93%20Read%20and%20Write%20Resources%20Created%20%28Sydney%29.png) |
| 11 | `/read` and `/write` resources created in Singapore | ![](screenshots/Screenshot%20%2311%20%E2%80%93%20Read%20and%20Write%20Resources%20Created%20%28Singapore%29.png) |
| 12 | API deployed to the `prod` stage in Singapore | ![](screenshots/Screenshot%20%2312%20%E2%80%93%20API%20Deployed%20%28Singapore%29.png) |
| 13 | API deployed to the `prod` stage in Sydney | ![](screenshots/Screenshot%20%2313%20%E2%80%93%20API%20Deployed%20%28Sydney%29.png) |
| 14 | ACM certificate requested in Sydney | ![](screenshots/Screenshot%20%2314%20%E2%80%93%20ACM%20Certificate%20Requested%20%28Sydney%29.png) |
| 15 | ACM certificate requested in Singapore | ![](screenshots/Screenshot%20%2315%20%E2%80%93%20ACM%20Certificate%20Requested%20%28Singapore%29.png) |
| 16 | API mapping configured in Sydney | ![](screenshots/Screenshot%20%2316%20%E2%80%93%20API%20Mapping%20Configured%20%28Sydney%29.png) |
| 17 | API mapping configured in Singapore | ![](screenshots/Screenshot%20%2317%20%E2%80%93%20API%20Mapping%20Configured%20%28Singapore%29.png) |
| 18 | Route 53 failover confirmed through a Singapore response | ![](screenshots/Screenshot%20%2318%20%E2%80%93%20Route%2053%20Failover%20Confirmed%20%28Singapore%20Response%29.png) |
| 19 | Route 53 failback confirmed through a Sydney response | ![](screenshots/Screenshot%20%2319%20%E2%80%93%20Route%2053%20Failback%20Confirmed%20%28Sydney%20Response%29.png) |
| 20 | Route 53 primary and secondary failover records | ![](screenshots/Screenshot%20%2320%20%E2%80%93%20Route%2053%20DNS%20Records%20%28Primary%20%26%20Secondary%29.png) |
| 21 | Route 53 health checks | ![](screenshots/Screenshot%20%2321%20%E2%80%93%20Route%2053%20Health%20Checks.png) |


## Challenges and Lessons Learned

During the implementation, several practical challenges were encountered and resolved:

- **API Gateway health checks:** Route 53 health checks must target the API Gateway invoke URL including the deployed stage and resource path (for example, `/prod/read`) rather than the custom domain root. This ensures the health check reaches a valid API endpoint and accurately reflects service availability.

- **Custom domain configuration:** Separate ACM certificates and custom domain mappings were required in each AWS Region before Route 53 failover records could be configured successfully.

- **REST API deployment:** Changes made to API Gateway resources and methods were not immediately available until the API was redeployed to the `prod` stage.

- **Regional consistency:** Maintaining identical Lambda functions, API Gateway configurations, IAM roles, and DynamoDB tables across both Regions simplified testing and ensured predictable failover behaviour.

- **Disaster recovery testing:** Validating failover required intentionally making the primary endpoint unavailable and allowing sufficient time for Route 53 health checks and DNS failover to complete.


## Key Skills Demonstrated

- Multi-Region AWS architecture design
- Serverless application development
- Disaster recovery planning and implementation
- Route 53 DNS failover and health checks
- REST API development with Amazon API Gateway
- Event-driven compute using AWS Lambda
- NoSQL database integration with Amazon DynamoDB
- IAM role and permission management
- SSL/TLS certificate management with AWS Certificate Manager
- End-to-end solution testing and validation
