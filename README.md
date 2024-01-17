# Example Infrastructure EKS - Terraform

## Run local Terraform

```bash
# Define profile
export AWS_PROFILE=eks
```

```bash
# Initialize Terraform
terraform init
```

```bash
# Select workspace
terraform workspace select staging
```

```bash
# Plan Terraform
terraform plan
```

```bash
# Apply Terraform
terraform apply
```

## Configure Kubectl
```bash
# Configure Kubectl for Production Cluster
aws eks --region sa-east-1 update-kubeconfig --alias eks-production-cluster --name eks-production-cluster --profile eks
# Configure Kubectl for Staging Cluster
aws eks --region us-east-1 update-kubeconfig --alias eks-staging-cluster --name eks-staging-cluster --profile eks
```


## Test Deployment of 2048 Game (Load Balancer Controller v2.5.3)

```bash
# Create a namespace for your ingress resources
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.3/docs/examples/2048/2048_full.yaml
```

```bash
# Delete 2048 Game Resources
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.3/docs/examples/2048/2048_full.yaml
```

## Verify RDS Engine Versions and Instance Classes Compatible

```bash
# Get RDS Engine Versions
aws rds describe-db-engine-versions --query 'DBEngineVersions[].EngineVersion'
```

```bash
# Get RDS Instance Classes
aws rds describe-orderable-db-instance-options --engine aurora-mysql --engine-version 8.0.mysql_aurora.3.04.0 --query 'OrderableDBInstanceOptions[].DBInstanceClass'
```
