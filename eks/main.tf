module "eks-network" {
   source = "../network-module"

   public_subnet_cidr_blocks = var.eks_private_subnet_cidr_blocks
   private_subnet_cidr_blocks = var.eks_public_subnet_cidr_blocks
   vpc_cidr = var.eks_vpc_cidr
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "eks-fargate-cluster"
  subnet_ids      = "${module.eks-network.w_private_subnet}"
  vpc_id          = "${module.eks-network.w_vpc}"
  cluster_version = "1.27"
#   fargate_profiles = {
#     eks_cluster_name = "eks-fargate-cluster"
#     subnet_ids      = "${module.eks-network.w_private_subnet}"
#   }
}

module "fargate_profile" {
  source = "terraform-aws-modules/eks/aws//modules/fargate-profile"

  name         = "separate-fargate-profile"
  cluster_name = "eks-fargate-cluster"

  subnet_ids = "${module.eks-network.w_private_subnet}"
  selectors = [{
    namespace = "default"
  }]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
