# VPC and Subnets
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "simple-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Name = "simple-vpc"
  }
}

# EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      desired_capacity = 2
      min_capacity     = 1
      max_capacity     = 3

      instance_types = ["t3.medium"]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# Get EKS auth
data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

# Kubernetes Deployment
resource "kubernetes_deployment" "app" {
  metadata {
    name = "simple-timeservice"
    labels = {
      app = "simple-timeservice"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "simple-timeservice"
      }
    }

    template {
      metadata {
        labels = {
          app = "simple-timeservice"
        }
      }

      spec {
        container {
          name  = "simple-timeservice"
          image = var.app_image
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

# Kubernetes Service
resource "kubernetes_service" "app" {
  metadata {
    name = "simple-timeservice"
    labels = {
      app = "simple-timeservice"
    }
  }

  spec {
    selector = {
      app = "simple-timeservice"
    }

    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 3000
    }
  }
}
