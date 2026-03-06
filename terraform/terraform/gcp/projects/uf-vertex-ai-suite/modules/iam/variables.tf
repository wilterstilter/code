variable "project_id" {
  type        = string
  description = "Project Unique name - like uf-vertex-ai-suite"
  nullable    = false
  sensitive   = false
}

variable "project_iam_bindings" {
  type = map(object({
    entities = list(string)
  }))
}
