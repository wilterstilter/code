variable "name" {
  description = "The name of the certificate"
  type        = string
}

variable "description" {
  description = "The description of the certificate"
  type        = string
}

variable "location" {
  description = "The location of the certificate"
  type        = string
}

variable "cert_pem" {
  description = "The path to the certificate file"
  type        = string
}

variable "key_pem" {
  description = "The path to the private key file"
  type        = string
}

variable "scope" {
  description = "The scope of the certificate (DEFAULT, EDGE_CACHE, or ALL_REGIONS). Use ALL_REGIONS for Cross Region L7 ILB"
  type        = string
  default     = "DEFAULT"
}
