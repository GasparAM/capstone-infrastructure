cidr_block_vpc    = "10.0.0.0/16"
iam_name = "rdsFromEc2"
ami = "ami-0577c11149d377ab7"
compute_instance = "t3.micro"
rds_instance = "db.t3.micro"
# cidr_block_subnet = "10.0.1.0/24"
ingress_ips       = ["139.45.214.21/32", "0.0.0.0/0"]
tags = {
  Name    = "Terraform-test"
  Project = "2023_internship_yvn"
  Owner   = "gavetisyan"
  Matcher = "capstone_infrastructure"
}
