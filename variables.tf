variable "namespace" {
    type        = string
    default     = "gitea"
    description = "namespace to use for the installation"
}

variable "gitea_version" {
    type        = string
    default     = null
    description = "override the Gitea Helm chart version"
}

variable "storage_class" {
    type        = string
    default     = ""
    description = "storage class to use"
}

variable "gitea_storage_size" {
    type        = string
    default     = "10Gi"
    description = "storage size to use for Gitea"
}

variable "db_storage_size" {
    type        = string
    default     = "5Gi"
    description = "storage size to use for the database"
}

variable "host" {
    type        = string
    default     = null
    description = "FQDN for the ingress, must be set to configure ingress"
}

variable "ingress_class" {
    type        = string
    default     = null
    description = "ingress class to use"
}

variable "issuer_name" {
    type        = string
    default     = null
    description = "cert-manager issuer, use TLS if defined"
}

variable "issuer_type" {
    type        = string
    default     = "cluster-issuer"
    description = "cert-manager issuer type"
    validation {
        condition     = contains(["cluster-issuer", "issuer"], var.issuer_type)
        error_message = "issuer type must be 'issuer' or 'cluster-issuer'"
    }
}

variable "username" {
    type        = string
    default     = "gitea"
    description = "Gitea admin username"
}

variable "password" {
    type        = string
    default     = null
    description = "Gitea seed admin password (change after the installation)"
}
