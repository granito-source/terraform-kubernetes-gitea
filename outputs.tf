locals {
    protocol = var.issuer_name == null ? "http" : "https"
}

output "url" {
    depends_on  = [helm_release.gitea]
    value       = local.configure_ingress ? "${local.protocol}://${var.host}/" : null
    description = "installed application URL"
}
