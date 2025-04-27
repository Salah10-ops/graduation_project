# DevOps Pipeline for Redis-Backed Python Counter App

![alt text](image.png)

## Overview

This project demonstrates a complete DevOps pipeline setup for a Redis-backed Python counter application. It includes:
- Infrastructure provisioning using **Terraform**.
- Configuration management using **Ansible**.
- Containerization using **Docker**.
- Orchestration using **Kubernetes** (EKS).
- CI/CD pipeline setup with **Jenkins**.
- Monitoring using **Prometheus** and **Grafana**.

This guide walks you through the entire process of setting up the project from scratch.

---

## Prerequisites

Before you start, make sure you have the following tools installed:

- [Terraform](https://www.terraform.io/downloads.html) – For provisioning infrastructure.
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) – For configuration management.
- [Docker](https://docs.docker.com/get-docker/) – For building and running containers.
- [kubectl](https://kubernetes.io/docs/tasks/tools/) – To interact with Kubernetes clusters.
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) – To manage AWS resources.
- [eksctl](https://eksctl.io/introduction/installation/) – For creating and managing EKS clusters.
- **GitHub Account** – To clone the repository and manage CI/CD pipelines.

---

## Setup Instructions

### 1. Clone the Repository

Start by cloning the repository to your local machine:

```bash
git clone https://github.com/Salah10-ops/graduation_project.git

```

### 2. Configure AWS CLI

We need to configure the AWS CLI with the AWS credentials. Run the following command and provide your AWS access key, secret key, and region when prompted:

```bash

aws configure

```

1. AWS Access Key ID: AWS access key (in the AWS console under IAM).
2. AWS Secret Access Key: AWS secret key (generated in IAM).
3. Default region name: Choose us-east-1 or your preferred region.
4. Default output format: json.


---

## Infrastructure Setup

### Initialize and Apply Terraform

Navigate to the Terraform folder: 

```bash  
cd terraform/
terraform init
terraform plan
terraform apply
```
This will create the following resources:

1. EKS Cluster for container orchestration named devops-cluster.
2. VPC, Subnets, and Networking resources.
3. EC2 Instance for Jenkins.
4. IAM Roles and Policies for AWS access.

---

## Configuration Management (Ansible)

After the infrastructure is set up, we use Ansible to install dependencies and configure the environment.

1. Set Up Jenkins and EKS with Ansible

 1. Install Docker, Kubernetes tools, and set up Jenkins using Ansible:

```bash
cd ansible/
wsl
ansible-playbook -i /mnt/d/courses/DevOps/graduation_project/jenkins/ansible-playbook/inventory.ini dependencies.yml
```

    This will:
        Set up Jenkins on an EC2 instance, Configure AWS and EKS on the nodes and Install Kubernetes tools and Docker.


---

## Build and Deploy the App (Docker + Kubernetes)


1. Build the Docker Image
2. Push Docker Image to DockerHub (or AWS ECR)
3. Deploy the App to Kubernetes (EKS)
4. Expose the Application as a LoadBalancer service

```bash
cd app/
docker build -t python-counter-app .
docker tag python-counter-app 340752816389.dkr.ecr.us-east-1.amazonaws.com/python-app:latest
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 340752816389.dkr.ecr.us-east-1.amazonaws.com
docker push 340752816389.dkr.ecr.us-east-1.amazonaws.com/python-app:latest
kubectl apply -f k8s-manifests/
kubectl expose deployment python-app --type=LoadBalancer --port=80 -n prod
```

---

## Setting Up CI/CD with Jenkins

1. Access Jenkins

Jenkins is running on an EC2 instance in your AWS environment. Use the Jenkins LoadBalancer DNS to access it:

    Jenkins URL: http://184.72.175.236:8080/job/python-app-pipeline/

2. Install Necessary Jenkins Plugins

    In Jenkins, install the following plugins:

    Kubernetes Plugin

    Docker Plugin

    GitHub Plugin


3. Create a Jenkins Pipeline

    Create a new pipeline job in Jenkins and configure it to:
    
    1. Pull the code from your GitHub repository.
    
    2. Build the Docker image.
    
    3. Push the Docker image to AWS ECR.
    
    4. Deploy the app to Kubernetes (EKS) using kubectl.


This pipeline:

    1. Builds the Docker image.

    2. Pushes the Docker image to AWS ECR.

    3. Deploys the app to the test or prod environment based on the branch.


After that we need to allow the jenkins to connect to the Github repo to get the Jenkinsfile from jenkins directory and apply the stages and run K8s manifests as configured to create the new pods for the python and redis apps with the new images that will be pushed to any branches on the Github repo.

---

## Monitoring Setup (Prometheus + Grafana)

### Prerequisites

Before setting up Prometheus and Grafana, ensure you have Helm installed on your Jenkins server. Helm is a package manager for Kubernetes that helps you manage Kubernetes applications.

You can install Helm by following the Helm installation guide.

### Steps to Set Up Prometheus and Grafana Using Helm

1. Add Prometheus and Grafana Helm Repositories

To begin, you need to add the official Prometheus and Grafana Helm charts to your Helm repository. Run the following commands on your Jenkins server:

```bash 
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

2. Install Prometheus and Grafana

Once the Helm repositories are added, install Prometheus using the following Helm command. This will set up the Prometheus monitoring solution and Similarly, to install Grafana, in your Kubernetes cluster:

```bash 
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace

helm install grafana grafana/grafana --namespace monitoring
```


3. Set up External Access to Grafana & Prometheus

By default, Grafana and Prometheus might not be accessible externally. You need to expose them using LoadBalancer services (or Ingress if you're using ingress controllers) for external access. Here’s how to do that.

    1. For Prometheus

    Prometheus is generally accessed through port 9090. You will need to expose it via a LoadBalancer service:

```bash

kubectl expose svc prometheus-kube-prometheus-prometheus --type=LoadBalancer --name=prometheus-service --namespace monitoring --port=9090 --target-port=9090

```

This will create a LoadBalancer service for Prometheus, allowing it to be accessed externally.

    2. For Grafana
    
    Grafana is generally accessed via port 3000. You need to expose Grafana via a LoadBalancer service as well:

```bash

kubectl expose svc grafana --type=LoadBalancer --name=grafana-service --namespace monitoring --port=80 --target-port=3000

```

This will create a LoadBalancer service for Grafana, allowing you to access it externally on port 80.

4. Retrieve External IPs
After exposing both services, you can get the external IP addresses of Prometheus and Grafana:

```bash
kubectl get svc -n monitoring 

```

Access via LoadBalancer URLs:

Prometheus: http://affd56361779a470f9ba5cc7ddc051d7-1466244061.us-east-1.elb.amazonaws.com:9090

Grafana: http://a1a0db9d04520449ba074f6f8fb27fde-2135921855.us-east-1.elb.amazonaws.com:80

5. Login to Grafana (admin/admin123) and import dashboards for:

    1. Kubernetes cluster monitoring

    2. Jenkins server monitoring



