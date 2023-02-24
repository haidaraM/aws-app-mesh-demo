# https://docs.aws.amazon.com/app-mesh/latest/userguide/tls.html#virtual-node-tls-prerequisites
resource "aws_acm_certificate" "virtual_node_cert" {
  domain_name               = "${var.name}.${var.service_discovery_namespace_name}"
  certificate_authority_arn = var.private_ca_arn

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_appmesh_virtual_node" "node" {
  mesh_name = var.mesh_name
  name      = "vn-${var.name}"
  spec {
    service_discovery {
      aws_cloud_map {
        namespace_name = var.service_discovery_namespace_name
        service_name   = aws_service_discovery_service.service_discovery.name
      }
    }

    listener {
      port_mapping {
        port     = var.service_default_port
        protocol = "http"
      }

      # This is where the magic happens when tell envoy to do a TLS termination
      tls {
        mode = "STRICT"
        certificate {
          acm {
            certificate_arn = aws_acm_certificate.virtual_node_cert.arn
          }
        }
      }
    }


    logging {
      access_log {
        file {
          path = "/dev/stdout"
        }
      }
    }
  }
}
