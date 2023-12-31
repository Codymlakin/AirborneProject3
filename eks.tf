#test
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "EaglesCluster"
  cluster_version = "1.27"
    # count = var.public_subnet_count
  vpc_id                   = aws_vpc.main.id
  subnet_ids               = aws_subnet.subnet_private[*].id
  control_plane_subnet_ids = aws_subnet.subnet_public[*].id
  cluster_endpoint_public_access  = true
  # create_kms_key = false


  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }
  # aws-auth configmap
  # manage_aws_auth_configmap = true

  # aws_auth_roles = [
  #   {
  #     rolearn = "arn:aws:iam::785169158894:role/eksctl-vettec20230313-cluster-ServiceRole-1450QA3BKEFC" # Add Jenkins Server Role w/ EKS auth
  #     user    = "eagles"
  #     group   = ["system:masters"]
  #   },
  # ]
}


