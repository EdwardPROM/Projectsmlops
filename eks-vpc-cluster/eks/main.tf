locals {
  # Resolve VPC wiring from overrides or remote state
  vpc_id = var.vpc_id != null ? var.vpc_id : (
    try(data.terraform_remote_state.vpc.outputs.vpc_id, null)
  )

  private_subnet_ids = var.private_subnet_ids != null ? var.private_subnet_ids : (
    try(data.terraform_remote_state.vpc.outputs.private_subnets, [])
  )

  cpu_mng = {
    "cpu-nodes" = {
      desired_size   = var.cpu_desired_size
      min_size       = var.cpu_min_size
      max_size       = var.cpu_max_size
      instance_types = var.cpu_instance_types
      capacity_type  = "ON_DEMAND"
    }
  }

  gpu_mng = var.enable_gpu ? {
    "gpu-nodes" = {
      desired_size   = var.gpu_desired_size
      min_size       = var.gpu_min_size
      max_size       = var.gpu_max_size
      instance_types = var.gpu_instance_types
      ami_type       = "AL2_x86_64_GPU"
      capacity_type  = "ON_DEMAND"
    }
  } : {}

  eks_managed_node_groups = merge(local.cpu_mng, local.gpu_mng)
}

# Optional remote state of VPC (used if vpc_id/private_subnet_ids not provided)
data "terraform_remote_state" "vpc" {
  count   = var.vpc_id == null || var.private_subnet_ids == null ? 1 : 0
  backend = "s3"
  config = {
    bucket  = var.vpc_state_bucket
    key     = var.vpc_state_key
    region  = var.vpc_state_region
    profile = var.vpc_state_profile
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  vpc_id                          = local.vpc_id
  subnet_ids                      = local.private_subnet_ids
  enable_irsa                     = true
  cluster_endpoint_public_access  = true

  eks_managed_node_groups = local.eks_managed_node_groups

  tags = {
    Project     = "mlops"
    Environment = "dev"
    Terraform   = "true"
  }
}

