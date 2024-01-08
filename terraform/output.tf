output "db_cluster_id" {
  description = "Neptune Cluster Identifier"
  value = aws_cloudformation_stack.neptune_stack.outputs.DBClusterId
}

output "db_subnet_group_id" {
  description = "Neptune DBSubnetGroup Identifier"
  value = aws_cloudformation_stack.neptune_stack.outputs.DBSubnetGroupId
}

output "db_cluster_resource_id" {
  description = "Neptune Cluster Resource Identifier"
  value = aws_cloudformation_stack.neptune_stack.outputs.DBClusterResourceId
}

output "db_cluster_endpoint" {
  description = "Master Endpoint for Neptune Cluster"
  value = aws_cloudformation_stack.neptune_stack.outputs.DBClusterEndpoint
}

output "db_instance_endpoint" {
  description = "Master Instance Endpoint"
  value = aws_cloudformation_stack.neptune_stack.outputs.DBInstanceEndpoint
}

output "db_replica_instance_endpoint" {
  description = "ReadReplica Instance Endpoint"
  value = try(aws_cloudformation_stack.neptune_stack.outputs.DBReplicaInstanceEndpoint, null)
}

output "sparql_endpoint" {
  description = "Sparql Endpoint for Neptune"
  value = aws_cloudformation_stack.neptune_stack.outputs.SparqlEndpoint
}

output "gremlin_endpoint" {
  description = "Gremlin Endpoint for Neptune"
  value = aws_cloudformation_stack.neptune_stack.outputs.GremlinEndpoint
}

output "loader_endpoint" {
  description = "Loader Endpoint for Neptune"
  value = aws_cloudformation_stack.neptune_stack.outputs.LoaderEndpoint
}

output "db_cluster_read_endpoint" {
  description = "DB cluster Read Endpoint"
  value = aws_cloudformation_stack.neptune_stack.outputs.DBClusterReadEndpoint
}

output "db_cluster_port" {
  description = "Port for the Neptune Cluster"
  value = aws_cloudformation_stack.neptune_stack.outputs.DBClusterPort
}

output "neptune_load_from_s3_iam_role_arn" {
  description = "IAM Role for loading data in Neptune"
  value = aws_cloudformation_stack.neptune_stack.outputs.NeptuneLoadFromS3IAMRoleArn
}

output "neptune_iam_auth_user" {
  description = "IAM User for IAM Auth"
  value = aws_cloudformation_stack.neptune_stack.outputs.NeptuneIamAuthUser
}

output "ec2_client" {
  description = "EC2 client Identifier"
  value = aws_cloudformation_stack.neptune_ec2_client[0].outputs.EC2Client
}

output "ssh_access" {
  description = "This is how you gain remote access to the EC2 client."
  value = aws_cloudformation_stack.neptune_ec2_client[0].outputs.SSHAccess
}

output "vpc" {
  description = "VPC"
  value = aws_cloudformation_stack.neptune_stack.outputs.VPC
}

output "subnet1" {
  description = "Private Subnet1"
  value = aws_cloudformation_stack.neptune_stack.outputs.PrivateSubnet1
}

output "subnet2" {
  description = "Private Subnet2"
  value = aws_cloudformation_stack.neptune_stack.outputs.PrivateSubnet2
}

output "subnet3" {
  description = "Private Subnet3"
  value = local.az3_present ? aws_cloudformation_stack.neptune_stack.outputs.PrivateSubnet3 : null
}

output "subnet4" {
  description = "Public Subnet1"
  value = aws_cloudformation_stack.neptune_stack.outputs.PublicSubnet1
}

output "neptune_sagemaker_notebook" {
  description = "Neptune Sagemaker Notebook Name"
  value = aws_cloudformation_stack.neptune_sagemaker_notebook[0].outputs.NeptuneSagemakerNotebook
}

output "neptune_notebook_instance_lifecycle_config_id" {
  description = "Neptune Sagemaker Notebook Instance Lifecycle ConfigId"
  value = aws_cloudformation_stack.neptune_sagemaker_notebook[0].outputs.NeptuneNotebookInstanceLifecycleConfigId
}
