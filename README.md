# sentinel-split
rapyd assignment

# Sentinel Split – Infrastructure & CI/CD Documentation

Repository: [https://github.com/shamoon-a/sentinel-split.git]

---

## 1. Project Overview

This project demonstrates a **production-style Terraform + AWS + Kubernetes architecture** built within a limited timeframe, focusing on:

* Infrastructure as Code (Terraform)
* Secure, isolated networking across VPCs
* Kubernetes-based backend and gateway (proxy) pattern
* CI/CD automation using GitHub Actions

The design intentionally mirrors real-world cloud platform engineering patterns while keeping scope realistic for a short delivery window.

---

## 2. How to Clone and Run the Project

### Prerequisites

* AWS account with permissions for VPC, EKS, IAM, EC2, ELB
* AWS CLI configured locally
* Terraform >= 1.6.x
* kubectl
* GitHub account (for CI/CD)

### Clone the Repository

```bash
git clone https://github.com/shamoon-a/sentinel-split.git
cd sentinel-split
```

### Terraform – Provision Infrastructure

```bash
cd terraform/envs/poc
terraform init
terraform validate
terraform plan
terraform apply
```

This provisions:

* VPCs
* VPC peering
* EKS clusters (backend & gateway)
* Supporting IAM roles and networking

### Terraform State Management (Backend)

Current State

Terraform in this project is currently using the local backend for state management.

This means:

Terraform state (terraform.tfstate) is stored locally on the machine or CI runner executing Terraform

There is no remote state locking

There is no shared state across team members or pipelines

### Kubernetes – Manual Apply (optional / local)

```bash
kubectl apply -R -f k8s/backend/
kubectl apply -R -f k8s/gateway/
```

In normal operation, this is handled automatically by CI/CD.

---

## 3. Networking Architecture (VPCs & Clusters)

### High-level Design

* **Gateway VPC**

  * Hosts the NGINX gateway EKS cluster
  * Exposes a public AWS Load Balancer

* **Backend VPC**

  * Hosts the backend EKS cluster
  * No public ingress

* **VPC Peering**

  * Enables private IP communication between clusters
  * No traffic traverses the public internet

### Key Principles

* Strong network isolation
* Private traffic

---

## 4. How the Proxy (Gateway) Talks to the Backend

The gateway uses **NGINX as a reverse proxy** deployed inside Kubernetes.

Flow:

1. User accesses the public Load Balancer
2. Traffic reaches the NGINX gateway service
3. NGINX forwards requests to backend services via **private IPs / ClusterIP services**
4. Backend responds internally
5. Response is proxied back to the client

Benefits:

* Backend is never publicly exposed
* Centralized control of ingress
* Easy to add authentication, rate limiting, TLS later

---

## 5. NetworkPolicy & Security Model

### Current Model

* Kubernetes namespaces logically separate gateway and backend
* Traffic is allowed only where required
* No public ingress to backend services

This project keeps policies minimal due to time constraints, but the architecture is ready for stricter enforcement.

---

## 6. CI/CD Pipeline Structure (GitHub Actions)

Pipeline is defined in:

```
.github/workflows/ci-cd.yaml
```

### Trigger

* Runs automatically on every `push` to the `main` branch

### Jobs

#### 1. Terraform Job

* Checkout code
* Configure AWS credentials
* Terraform init
* Terraform validate
* Terraform plan
* Terraform apply


#### 2. Kubernetes Backend Deployment

* Update kubeconfig for backend cluster
* Dry-run Kubernetes manifests
* Deploy backend workloads
* Verify rollout

#### 3. Kubernetes Gateway Deployment

* Update kubeconfig for gateway cluster
* Dry-run gateway manifests
* Deploy NGINX gateway
* Verify rollout

---

## 7. Trade-offs Due to the 3-Day Time Limit

To stay focused and deliver a complete, working system:

* Terraform using the local backend for state management. (Instead of S3+DynamoDB or S3 Object Lock)
* Minimal NetworkPolicy rules
* No TLS/mTLS yet
* Limited observability tooling
* No GitOps controller (e.g. ArgoCD)

These were conscious trade-offs, not design limitations.

---

## 8. Cost Optimization Notes (Optional)

* Single NAT Gateway per VPC (instead of per AZ)
* Sensible EC2 instance sizing for EKS nodes
* AWS-managed Load Balancer instead of custom ingress stack
* No always-on monitoring stack

The setup is suitable for evaluation environments.

---

## 9. What I Would Do Next (Production Roadmap)

If extended further, the next steps would be:

### Security

* TLS termination at gateway
* mTLS between services
* AWS ACM integration
* Fine-grained NetworkPolicies

### Platform & Observability

* Prometheus + Grafana
* Fluent Bit / OpenSearch
* AWS CloudWatch Container Insights

### Delivery & Operations

* GitOps with ArgoCD or Flux
* Progressive delivery (canary / blue-green)

---

## 10. Final Notes

This project intentionally balances **clarity, correctness, and realism**.
It demonstrates not just *what* was built, but *why* architectural decisions were made.

Designed for review by engineering managers and senior DevOps / platform engineers.

