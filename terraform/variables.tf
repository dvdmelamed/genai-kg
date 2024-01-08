locals {
  create_db_replica_instance = var.db_replica_identifier_suffix != ""
  az3_not_present = anytrue([data.aws_region.current.name == "ca-central-1", data.aws_region.current.name == "us-west-1"])
  az3_present = !local.az3_not_present
  create_ec2_instance = var.ec2_client_instance_type != "none"
  create_sagemaker_notebook = var.notebook_instance_type != "none"
}

#variable ec2_ssh_key_pair_name {
#  description = "OPTIONAL: Name of an existing EC2 KeyPair to enable SSH access to the instances. Required only if an EC2ClientInstanceType is specified"
#  type = string
#}

variable env {
  description = "Environment tag, e.g. prod, nonprod."
  type = string
  default = "test"
}

variable db_instance_type {
  description = "Neptune DB instance type"
  type = string
  default = "db.serverless"
}

variable min_nc_us {
  description = "Min NCUs to be set on the Neptune cluster(Should be less than or equal to MaxNCUs). Required if DBInstance type is db.serverless"
  type = string
  default = 2.5
}

variable max_nc_us {
  description = "Max NCUs to be set on the Neptune cluster(Should be greater than or equal to MinNCUs). Required if DBInstance type is db.serverless"
  type = string
  default = 128
}

variable db_replica_identifier_suffix {
  description = "OPTIONAL: The ID for the Neptune Replica to use. Empty means no read replica. Maximum Length allowed is 32 characters."
  type = string
}

variable db_cluster_id {
  description = "OPTIONAL: Enter the Cluster id of your Neptune cluster. Maximum Length allowed is 38 characters."
  type = string
}

variable db_cluster_port {
  description = "Enter the port of your Neptune cluster"
  type = string
  default = "8182"
}

variable ec2_client_instance_type {
  description = "OPTIONAL: EC2 client instance. Required only if EC2 client needs to setup. Please refer to https://aws.amazon.com/ec2/pricing/ for pricing."
  type = string
  default = "t3.micro"
}

variable neptune_query_timeout {
  description = "Neptune Query Time out (in milliseconds)"
  type = string
  default = 20000
}

variable neptune_enable_audit_log {
  description = "Enable Audit Log. 0 means disable and 1 means enable."
  type = string
  default = 0
}

variable iam_auth_enabled {
  description = "Enable IAM Auth for Neptune."
  type = string
  default = "false"
}

variable setup_gremlin_console {
  description = "OPTIONAL: Setup Gremlin console on EC2 client. Used only if EC2ClientInstanceType is specified."
  type = string
  default = "false"
}

variable setup_rdf4_j_console {
  description = "OPTIONAL: Setup RDF4J console on EC2 client. Used only if EC2ClientInstanceType is specified."
  type = string
  default = "false"
}

variable attach_bulkload_iam_role_to_neptune_cluster {
  description = "Attach Bulkload IAM role to cluster"
  type = string
  default = "true"
}

variable notebook_instance_type {
  description = "SageMaker Notebook instance type. Please refer https://aws.amazon.com/sagemaker/pricing/ for uptodate allowed instance type in aws region and https://aws.amazon.com/neptune/pricing/ for pricing."
  type = string
  default = "ml.t2.medium"
}

variable neptune_sagemaker_notebook_startup_script {
  description = "OPTIONAL: Startup script additions for the notebook instance."
  type = string
}