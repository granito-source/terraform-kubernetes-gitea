resource "kubernetes_namespace" "gitea" {
    metadata {
        name = var.namespace
    }
}

resource "random_password" "database" {
    length  = 14
    special = false
}

locals {
    configure_ingress = var.host != null
}

resource "helm_release" "gitea" {
    namespace  = kubernetes_namespace.gitea.metadata[0].name
    name       = "gitea"
    repository = "https://dl.gitea.com/charts"
    chart      = "gitea"
    version    = var.gitea_version
    values     = [
        <<-EOT1
        global:
          storageClass: ${var.storage_class}
        gitea:
          admin:
            username: ${var.username}
        persistence:
          size: ${var.gitea_storage_size}
        postgresql-ha:
          global:
            postgresql:
              password: ${random_password.database.result}
          postgresql:
            repmgrPassword: ${random_password.database.result}
            postgresPassword: ${random_password.database.result}
            password: ${random_password.database.result}
          pgpool:
            adminPassword: ${random_password.database.result}
          primary:
            persistence:
              size: ${var.db_storage_size}
        EOT1
    ,
        var.password == null ? "" : <<-EOT2
        gitea:
          admin:
            password: ${var.password}
        EOT2
    ,
        !local.configure_ingress ? "" : <<-EOT3
        ingress:
          enabled: true
          className: ${var.ingress_class}
          annotations:
          hosts:
            - host: ${var.host}
              paths:
                - path: /
                  pathType: Prefix
        EOT3
    ,
        !local.configure_ingress || var.issuer_name == null ? "" : <<-EOT4
        ingress:
          annotations:
            cert-manager.io/${var.issuer_type}: ${var.issuer_name}
          tls:
            - secretName: gitea-tls
              hosts:
                - ${var.host}
        EOT4
    ]
}
