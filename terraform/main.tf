data "aws_region" "current" {}

resource "tls_private_key" "terraform_generated_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.db_cluster_id}-ssh"
  public_key = tls_private_key.terraform_generated_private_key.public_key_openssh

  # Generate and save private key in current directory
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.terraform_generated_private_key.private_key_pem}' > ${var.db_cluster_id}.pem
      chmod 400 ${var.db_cluster_id}.pem
    EOT
  }
}

resource "aws_cloudformation_stack" "neptune_stack" {
  template_url = join("", ["https://s3.amazonaws.com/aws-neptune-customer-samples/v2/cloudformation-templates/neptune-base-stack.json"])
  timeout_in_minutes = "60"
  parameters = {
    Env = var.env
    DBReplicaIdentifierSuffix = var.db_replica_identifier_suffix
    DBClusterId = var.db_cluster_id
    DBClusterPort = var.db_cluster_port
    DbInstanceType = var.db_instance_type
    NeptuneQueryTimeout = var.neptune_query_timeout
    NeptuneEnableAuditLog = var.neptune_enable_audit_log
    IamAuthEnabled = var.iam_auth_enabled
    AttachBulkloadIAMRoleToNeptuneCluster = var.attach_bulkload_iam_role_to_neptune_cluster
    MinNCUs = var.min_nc_us
    MaxNCUs = var.max_nc_us
  }
  name = "neptune-stack"
  capabilities = ["CAPABILITY_IAM"]
}

resource "aws_cloudformation_stack" "neptune_ec2_client" {
  count = local.create_ec2_instance ? 1 : 0
  template_url = join("", ["https://s3.amazonaws.com/aws-neptune-customer-samples/v2/cloudformation-templates/neptune-ec2-client.json"])
  timeout_in_minutes = "30"
  parameters = {
    Env = var.env
    EC2SSHKeyPairName = aws_key_pair.generated_key.key_name
    EC2ClientInstanceType = var.ec2_client_instance_type
    SetupGremlinConsole = var.setup_gremlin_console
    SetupRDF4JConsole = var.setup_rdf4_j_console
    VPC = aws_cloudformation_stack.neptune_stack.outputs.VPC
    Subnet = aws_cloudformation_stack.neptune_stack.outputs.PublicSubnet1
    NeptuneDBCluster = aws_cloudformation_stack.neptune_stack.outputs.DBClusterId
    NeptuneDBClusterEndpoint = aws_cloudformation_stack.neptune_stack.outputs.DBClusterEndpoint
    NeptuneDBClusterPort = aws_cloudformation_stack.neptune_stack.outputs.DBClusterPort
    NeptuneClientRole = aws_cloudformation_stack.neptune_stack.outputs.NeptuneClientRole
  }
  name = "neptune-ec2-client"
  capabilities = ["CAPABILITY_IAM"]

  depends_on = [aws_key_pair.generated_key]
}

resource "aws_cloudformation_stack" "neptune_sagemaker_notebook" {
  count = local.create_sagemaker_notebook ? 1 : 0
  template_url = join("", ["https://s3.amazonaws.com/aws-neptune-customer-samples/v2/cloudformation-templates/neptune-sagemaker-notebook-stack.json"])
  timeout_in_minutes = "30"
  parameters = {
    Env = var.env
    NotebookInstanceType = var.notebook_instance_type
    NeptuneClusterEndpoint = aws_cloudformation_stack.neptune_stack.outputs.DBClusterEndpoint
    NeptuneClusterPort = aws_cloudformation_stack.neptune_stack.outputs.DBClusterPort
    NeptuneClusterVpc = aws_cloudformation_stack.neptune_stack.outputs.VPC
    NeptuneClusterSubnetId = aws_cloudformation_stack.neptune_stack.outputs.PublicSubnet1
    NeptuneClientSecurityGroup = aws_cloudformation_stack.neptune_stack.outputs.NeptuneSG
    NeptuneLoadFromS3RoleArn = aws_cloudformation_stack.neptune_stack.outputs.NeptuneLoadFromS3IAMRoleArn
    StartupScript = var.neptune_sagemaker_notebook_startup_script
    DBClusterId = aws_cloudformation_stack.neptune_stack.outputs.DBClusterId
    NeptuneClusterResourceId = aws_cloudformation_stack.neptune_stack.outputs.DBClusterResourceId
    EnableIamAuthOnNeptune = var.iam_auth_enabled
  }
  name = "neptune-sagemaker-notebook"
  capabilities = ["CAPABILITY_IAM"]
}
