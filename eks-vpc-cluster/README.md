# EKS + VPC (Terraform)

This project provisions a production-style AWS VPC and an EKS cluster using official Terraform modules:

- VPC: `terraform-aws-modules/vpc/aws`
- EKS: `terraform-aws-modules/eks/aws`

Two EKS managed node groups are created:

- `cpu-nodes`: general purpose (default `t3.medium`)
- `gpu-nodes`: optional GPU nodes (default `g4dn.xlarge`, disabled by default via size=0 in root; set sizes as needed)

Important: Destroy resources when done to avoid costs: `terraform destroy`.

## Layout

```
eks-vpc-cluster/
├── backend.tf
├── main.tf
├── outputs.tf
├── terraform.tf
├── variables.tf
├── vpc/
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── terraform.tf
│   └── variables.tf
└── eks/
    ├── backend.tf
    ├── main.tf
    ├── outputs.tf
    ├── terraform.tf
    └── variables.tf
```

Each of `vpc/` and `eks/` can be used as standalone root modules (with their own backends), or together via the root `eks-vpc-cluster/` which wires them as modules. Backends are defined as partial S3 configs — pass specifics during `terraform init`.

## Prerequisites

- Terraform >= 1.3
- AWS credentials configured (profile or environment variables)
- S3 bucket + optional DynamoDB table for state/locks

## Option A: Deploy via root (recommended for a single command)

This deploys VPC then EKS in one `apply`. The EKS module receives VPC outputs directly (no remote state lookup).

```
cd eks-vpc-cluster

# Initialize with your backend settings
terraform init \
  -backend-config="bucket=<your-bucket>" \
  -backend-config="key=env/dev/terraform.tfstate" \
  -backend-config="region=<aws-region>" \
  -backend-config="dynamodb_table=<lock-table>" \
  -backend-config="encrypt=true"

# Review and adjust variables if needed
terraform plan -var="region=<aws-region>" -out plan.out
terraform apply plan.out
```

## Option B: Deploy VPC then EKS as separate stacks (remote state)

1) VPC

```
cd eks-vpc-cluster/vpc
terraform init \
  -backend-config="bucket=<your-bucket>" \
  -backend-config="key=vpc/terraform.tfstate" \
  -backend-config="region=<aws-region>" \
  -backend-config="dynamodb_table=<lock-table>" \
  -backend-config="encrypt=true"
terraform apply
```

2) EKS (reads VPC via `data.terraform_remote_state`)

```
cd ../eks
terraform init \
  -backend-config="bucket=<your-bucket>" \
  -backend-config="key=eks/terraform.tfstate" \
  -backend-config="region=<aws-region>" \
  -backend-config="dynamodb_table=<lock-table>" \
  -backend-config="encrypt=true"

# Supply the VPC state location as variables
terraform apply \
  -var="region=<aws-region>" \
  -var="vpc_state_bucket=<your-bucket>" \
  -var="vpc_state_key=vpc/terraform.tfstate" \
  -var="vpc_state_region=<aws-region>" \
  -var="vpc_state_profile=<optional-aws-profile>"
```

## Access the cluster

```
aws eks --region <aws-region> update-kubeconfig --name <cluster-name>
kubectl get nodes -o wide
```

With defaults: `--name mlops-cluster` and region from variables.

## Tuning node groups

- CPU sizes: `cpu_desired_size`, `cpu_min_size`, `cpu_max_size`, `cpu_instance_types`
- GPU sizes: `gpu_desired_size`, `gpu_min_size`, `gpu_max_size`, `gpu_instance_types`, `enable_gpu`

If your region does not support `g4dn.xlarge`, pick an available GPU type or set GPU sizes to 0.

## Cleanup

Destroy EKS first, then VPC if using separate stacks. If using the root stack:

```
terraform destroy
```

You may keep the S3 bucket for state to avoid losing history, otherwise remove it manually after destroying Terraform-managed resources.

