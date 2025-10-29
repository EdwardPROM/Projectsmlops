variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "mlops-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "enable_nat_gateway" {
  description = "Create NAT Gateway(s) for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway across all AZs"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "mlops-cluster"
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.29"
}

variable "enable_gpu" {
  description = "Create GPU node group"
  type        = bool
  default     = true
}

variable "cpu_instance_types" {
  description = "CPU instance types"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "cpu_desired_size" {
  description = "CPU nodegroup desired size"
  type        = number
  default     = 2
}

variable "cpu_min_size" {
  description = "CPU nodegroup min size"
  type        = number
  default     = 1
}

variable "cpu_max_size" {
  description = "CPU nodegroup max size"
  type        = number
  default     = 3
}

variable "gpu_instance_types" {
  description = "GPU instance types"
  type        = list(string)
  default     = ["g4dn.xlarge"]
}

variable "gpu_desired_size" {
  description = "GPU nodegroup desired size"
  type        = number
  default     = 0
}

variable "gpu_min_size" {
  description = "GPU nodegroup min size"
  type        = number
  default     = 0
}

variable "gpu_max_size" {
  description = "GPU nodegroup max size"
  type        = number
  default     = 2
}

