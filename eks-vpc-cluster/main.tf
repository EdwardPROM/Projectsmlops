module "vpc" {
  source = "./vpc"

  region              = var.region
  vpc_name            = var.vpc_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs= var.private_subnet_cidrs
  availability_zones  = var.availability_zones
  enable_nat_gateway  = var.enable_nat_gateway
  single_nat_gateway  = var.single_nat_gateway
}

module "eks" {
  source = "./eks"

  region          = var.region
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Pass VPC wiring directly (overrides remote state inside eks/)
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  enable_gpu         = var.enable_gpu
  cpu_instance_types = var.cpu_instance_types
  cpu_desired_size   = var.cpu_desired_size
  cpu_min_size       = var.cpu_min_size
  cpu_max_size       = var.cpu_max_size

  gpu_instance_types = var.gpu_instance_types
  gpu_desired_size   = var.gpu_desired_size
  gpu_min_size       = var.gpu_min_size
  gpu_max_size       = var.gpu_max_size
}
