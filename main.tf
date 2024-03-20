resource "kubernetes_namespace" "gitea" {
    metadata {
        name = var.namespace
    }
}

resource "helm_release" "gitea" {
    namespace  = kubernetes_namespace.gitea.metadata[0].name
    name       = "gitea"
    repository = "https://dl.gitea.com/charts"
    chart      = "gitea"
    version    = var.gitea_version
    values     = [
        <<-EOT
        persistence:
          size: ${var.storage_size}
          storageClass: ${var.storage_class}
        ingress:
          enabled: true
          className: ${var.ingress_class_name}
          annotations:
          hosts:
            - host: ${var.host}
              paths:
                - path: /
                  pathType: Prefix
        EOT
    , var.issuer_name == null ? "" : <<-EOT
        ingress:
          annotations:
            cert-manager.io/${var.issuer_type}: ${var.issuer_name}
          tls:
            - secretName: gitea-tls
              hosts:
                - ${var.host}
        EOT
    ]
}
