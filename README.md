# SimpleTimeService 

This repository contains a minimal Node.js microservice called `SimpleTimeService`, containerized with Docker, and deployed to AWS using Terraform with EKS and Load Balancer. The infrastructure is fully parameterized and built following Infrastructure as Code (IaC) best practices.

---

## 📁 Project Structure

```
.
├── app             # Node.js microservice + Dockerfile
└── terraform       # Terraform modules for AWS infrastructure (VPC, EKS, ALB)
```

---

## 📦 Task 1 - SimpleTimeService (Node.js App)

### 📌 What it does

A minimal web service that responds with the current server time and the requestor's IP address in JSON format.

Example response from `/`:
```json
{
  "timestamp": "2025-04-11T18:30:00.000Z",
  "ip": "203.0.113.10"
}
```

---

### 🚀 Running Locally with Docker

1. Build the container:
   ```bash
   docker build -t simple-timeservice .
   ```

2. Run the container:
   ```bash
   docker run -p 3000:3000 simpletimeservice
   ```

3. Test:
   Open your browser or use curl:
   ```bash
   curl http://localhost:3000
   ```

---

### 🐳 Docker Image (Public)

This image is pushed to Docker Hub:

```
docker tag simpletimeservice:latest rajuyuva/simpletimeservice:v1

docker push rajuyuva/simpletimeservice:v1
```

Make sure to update this with your actual Docker Hub repo.

---

## ☁️ Task 2 - Infrastructure Deployment with Terraform

### 🌐 What it creates

- VPC with 2 public + 2 private subnets
- EKS Cluster (control plane + worker nodes in private subnets)
- Application deployed via Kubernetes Deployment
- ALB (Application Load Balancer) in public subnets to route traffic to the app

---

### 🔧 Prerequisites

Before you begin, ensure the following tools are installed:

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Docker](https://docs.docker.com/get-docker/) *(for building/pushing your image)*

---

### 🔐 Authentication

You must have valid AWS credentials configured via one of the following:

- Environment variables:
  ```bash
  export AWS_ACCESS_KEY_ID=your-access-key
  export AWS_SECRET_ACCESS_KEY=your-secret-key
  ```
- Or via `aws configure`:
  ```bash
  aws configure
  ```

Ensure your IAM user has permissions for EKS, VPC, EC2, IAM, ELB, and related services.

---

### ⚙️ Deployment Steps

```bash
cd terraform

# Initialize the Terraform project
terraform init

# Optional: Review the execution plan
terraform plan

# Apply the infrastructure
terraform apply
```

After a few minutes, Terraform will output the load balancer DNS endpoint. Use it to test your app:

```bash
curl http://<alb_dns_name>
```

---

## ⚙️ Terraform Inputs

Update these values in `terraform/terraform.tfvars`:

```hcl
aws_region  = "us-east-1"
app_image   = "yourdockerhub/simpletimeservice:latest"
cluster_name = "simple-timeservice-cluster"
```

All variables are defined in `variables.tf`.

---

## ✅ Verification

Check if everything worked:

- Run: `kubectl get nodes`, `kubectl get pods`, `kubectl get svc`
- Access the `/` endpoint on the ALB
- Confirm correct JSON response

---

## 🧠 Notes

- Container runs as a **non-root user** for security.
- Terraform project is fully **parameterized** with variables.
- Follows best practices: small Docker image, minimal app, IaC with Terraform.
- No secrets are committed to this repo.

---

