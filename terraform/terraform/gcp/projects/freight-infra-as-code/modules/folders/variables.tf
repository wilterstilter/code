variable "organization_id" {
  type        = string
  description = "GCP Organization ID for Uber Freight"
}

variable "environments" {
  type        = map(string)
  description = "Map of environment key and name"
}
