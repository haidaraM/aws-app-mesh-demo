resource "aws_appmesh_mesh" "the_mesh" {
  name = var.prefix
  spec {
    # We use ALLOW_ALL here and manage access to external services via the security group or a proxy
    egress_filter {
      type = "ALLOW_ALL"
    }
  }
}
