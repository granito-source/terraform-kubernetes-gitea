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
    description = "storage class to use for gitea-shared-storage"
}

variable "storage_size" {
    type        = string
    default     = "10Gi"
    description = "storage size to use for PVCs"
}

variable "host" {
    type        = string
    description = "FQDN for the ingress"
}

variable "ingress_class_name" {
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
