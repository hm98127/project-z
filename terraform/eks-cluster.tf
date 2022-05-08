# aws iam role create 
resource "aws_iam_role" "loljoa2-eks-cluster" {
  name = "loljoa2-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Terraform eks cluster 역할에 EKS-Cluster 정책 적용
resource "aws_iam_role_policy_attachment" "loljoa2-eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.loljoa2-eks-cluster.name
}


# Optionally, enable Security Groups for Pods
resource "aws_iam_role_policy_attachment" "loljoa2-eks-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.loljoa2-eks-cluster.name
}

resource "aws_iam_role_policy_attachment" "loljoa2-eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.loljoa2-eks-cluster.name
}

# Creating the EKS cluster

resource "aws_eks_cluster" "loljoa2-eks-cluster" {
  name     = "loljoa2-eks-cluster"
  role_arn =  "${aws_iam_role.loljoa2-eks-cluster.arn}"
  version  = "1.21"

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
# Adding VPC Configuration

  vpc_config {             # Configure EKS with vpc and network settings
    security_group_ids = [aws_security_group.loljoa2-eks-sg.id]
    subnet_ids         = [aws_subnet.loljoa2-pri-sub-a.id, aws_subnet.loljoa2-pri-sub-c.id]
   # 클러스터 엔드포인트(현재 VPC외내부에서 모두 엔드포인트에 접근할수있게함)
    endpoint_private_access = true
    endpoint_public_access = true
  }

  depends_on = [
    "aws_iam_role_policy_attachment.loljoa2-eks-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.loljoa2-eks-cluster-AmazonEKSVPCResourceController",
    "aws_iam_role_policy_attachment.loljoa2-eks-cluster-AmazonEKSServicePolicy"
   ]
}
