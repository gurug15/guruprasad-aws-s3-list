# AWS Assignment Project

## Overview

This project implements a two-part solution to demonstrate skills in application development and Infrastructure as Code (IaC). The assignment is divided into the following sections:

1. **HTTP Service**: A RESTful API that lists the contents of an S3 bucket.
2. **Terraform Deployment**: A Terraform layout to provision the required AWS infrastructure and deploy the HTTP service.

---

## Features

### Part 1: HTTP Service
- **Endpoint**: `GET /list-bucket-content/<path>`
  - Returns the contents of the specified S3 bucket path.
  - If no path is provided, it lists the top-level bucket contents.
  - Responses are in JSON format.
- **Error Handling**: Gracefully handles invalid or non-existent paths.
- **Example Responses**:
  - **Bucket Structure**:
    ```
    |_ dir1
    |_ dir2
    |_ file1
    |_ file2
    ```
  - **GET /list-bucket-content**:
    ```json
    {"content":[{"name":"GO","type":"folder"},{"name":"Jenkins","type":"folder"},{"name":"sketch (1).png","type":"file"},{"name":"sketch.png","type":"file"}]}
    ```
  - **GET /list-bucket-content/dir1**:
    ```json
    {"content": [{"name":"GO","type":"folder"},...]}
    ```

### Part 2: Terraform Deployment
- Infrastructure provisioned includes:
  - EC2 Compute resources for hosting the service 
- Deployment automates:
  - Creation and configuration of AWS resources.
  - Secure and reliable hosting for the HTTP service.
---

## Prerequisites
- AWS account with access to create resources.
- Terraform installed on your local system.
- Programming language environment (Node.js).

---

## Setup Instructions

### HTTP Service
1. Clone the repository:
   ```bash
   git clone https://github.com/gurug15/guruprasad-aws-s3-list.git
   ```
2. Navigate to the app directory:
   ```bash
   cd app
   ```
3. Install dependencies (if applicable):
   ```bash
   npm install -g typescript
   ```
4. Run the service locally:
   ```bash
   npm run dev
   ```

### Terraform Deployment
1. Navigate to the Terraform directory:
   ```bash
   cd terraform-code
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. plan and validate the Terraform plan:
   ```bash
   terraform plan -var-file=<<your xyz.tfvar file>>
   ```
3. Review and apply the Terraform plan:
   ```bash
   terraform apply -var-file=<<your xyz.tfvar file>>
   ```
3. Review and destroy the Terraform plan:
   ```bash
   terraform destroy -var-file=<<your xyz.tfvar file>>
   ```
4. Confirm deployment and note the public endpoint provided.

---

## Assumptions
- The S3 bucket and structure are pre-created and accessible.
- API requests to the HTTP service use valid AWS credentials.

---

## Challenges Faced
- Configuring IAM roles for secure access to the S3 bucket.
- Debugging Terraform modular issues.

---

## Screenshots and Demo
- Screenshots of the S3 bucket structure and API responses are included in the `media` directory.
- A video demo of the project is included as `demo.mp4`.

---

## Cleanup
After testing, ensure all AWS resources are terminated to avoid unnecessary charges:
```bash
terraform destroy
```

---

## Conclusion
This project demonstrates skills in API development, AWS resource provisioning, and secure deployment using Terraform.
