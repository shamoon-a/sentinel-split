# IAM roles MUST respect prefixes: eks-*


resource "aws_iam_role" "eks_gateway_cluster" {
  name               = "eks-gateway-cluster"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster.json
}


resource "aws_iam_role" "eks_gateway_nodes" {
  name               = "eks-gateway-nodes"
  assume_role_policy = data.aws_iam_policy_document.eks_nodes.json
}


resource "aws_iam_role" "eks_backend_cluster" {
  name               = "eks-backend-cluster"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster.json
}


resource "aws_iam_role" "eks_backend_nodes" {
  name               = "eks-backend-nodes"
  assume_role_policy = data.aws_iam_policy_document.eks_nodes.json
}

resource "aws_iam_role_policy_attachment" "gateway_nodes_worker" {
  role       = aws_iam_role.eks_gateway_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "gateway_nodes_cni" {
  role       = aws_iam_role.eks_gateway_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "gateway_nodes_ecr" {
  role       = aws_iam_role.eks_gateway_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Repeat for backend

resource "aws_iam_role_policy_attachment" "backend_nodes_worker" {
  role       = aws_iam_role.eks_backend_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "backend_nodes_cni" {
  role       = aws_iam_role.eks_backend_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "backend_nodes_ecr" {
  role       = aws_iam_role.eks_backend_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# EKS CLUSTER POLICY

resource "aws_iam_role_policy_attachment" "gateway_cluster_policy" {
  role       = aws_iam_role.eks_gateway_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "backend_cluster_policy" {
  role       = aws_iam_role.eks_backend_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
