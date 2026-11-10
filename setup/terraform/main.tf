###################################################
# 1. Existing VPC & Subnets (ap-southeast-2)
###################################################
data "aws_vpc" "default" {
  id = "vpc-0e4db0d301dab2fcf"
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

###################################################
# 2. ECR Repositories
###################################################
resource "aws_ecr_repository" "frontend" {
  name                 = "frontend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "backend" {
  name                 = "backend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

###################################################
# 3. Existing IAM Roles & User Lookups
###################################################
data "aws_iam_role" "eks_cluster" {
  name = "eks_cluster_role"
}

data "aws_iam_role" "node_group" {
  name = "udacity-node-group"
}

data "aws_iam_user" "github_action_user" {
  user_name = "github-action-user"
}

###################################################
# 4. Amazon EKS Cluster
###################################################
resource "aws_eks_cluster" "main" {
  name     = "cluster"
  version  = "1.31"
  role_arn = data.aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids              = slice(data.aws_subnets.default.ids, 0, 2)
    endpoint_public_access  = true
    endpoint_private_access = true
  }
}

###################################################
# 5. EKS Managed Node Group
###################################################
resource "aws_eks_node_group" "main" {
  node_group_name = "udacity"
  cluster_name    = aws_eks_cluster.main.name
  version         = aws_eks_cluster.main.version
  node_role_arn   = data.aws_iam_role.node_group.arn
  subnet_ids      = slice(data.aws_subnets.default.ids, 0, 2)
  instance_types  = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  lifecycle {
    ignore_changes = [scaling_config.0.desired_size]
  }
}