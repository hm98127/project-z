# eks worker nodes iam role create 
resource "aws_iam_role" "loljoa2-eks-node" {
  name = "loljoa2-eks-node"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "loljoa2-eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.loljoa2-eks-node.name
}

resource "aws_iam_role_policy_attachment" "loljoa2-eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.loljoa2-eks-node.name
}

resource "aws_iam_role_policy_attachment" "loljoa2-eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.loljoa2-eks-node.name
}

# eks worker nodes create 
resource "aws_eks_node_group" "loljoa2-eks-node" {
  cluster_name    = aws_eks_cluster.loljoa2-eks-cluster.name
  node_group_name = "loljoa2-eks-node"
  node_role_arn   = aws_iam_role.loljoa2-eks-node.arn
  subnet_ids      = [aws_subnet.loljoa2-pri-sub-a.id, aws_subnet.loljoa2-pri-sub-c.id]
  instance_types = ["t2.medium"]
  disk_size = 30

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.loljoa2-eks-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.loljoa2-eks-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.loljoa2-eks-node-AmazonEC2ContainerRegistryReadOnly,
  ]
  
  tags = {
    Name = "${aws_eks_cluster.loljoa2-eks-cluster.name}-node"
  }
}
