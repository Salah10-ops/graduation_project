#output "eks_cluster_name" {
#  value = aws_eks_cluster.eks_cluster.name
#}
#
#output "eks_cluster_endpoint" {
#  value = aws_eks_cluster.eks_cluster.endpoint
#}
#
#output "eks_cluster_ca_certificate" {
#  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
#}
#
#output "eks_cluster_kubeconfig" {
#  value = <<EOF
#apiVersion: v1
#clusters:
#- cluster:
#    certificate-authority-data: ${aws_eks_cluster.eks_cluster.certificate_authority[0].data}
#    server: ${aws_eks_cluster.eks_cluster.endpoint}
#  name: ${aws_eks_cluster.eks_cluster.name}
#contexts:
#- context:
#    cluster: ${aws_eks_cluster.eks_cluster.name}
#    user: aws
#  name: ${aws_eks_cluster.eks_cluster.name}
#current-context: ${aws_eks_cluster.eks_cluster.name}
#kind: Config
#users:
#- name: aws
#  user:
#    token: ${data.aws_eks_cluster_auth.cluster_auth.token}
#EOF
#  sensitive = true
#}