variable "project_id" {
  description = "The GCP project ID where resources will be created"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "location" {
  description = "The location of the GKE cluster"
  type        = string
}

# --- CONTAINER REGISTRY CONFIGURATION ---
variable "gar_project_id" {
  description = "The GCP project ID where the Google Artifact Registry is located"
  type        = string
  default     = "uf-build-p"
}

variable "gar_location" {
  description = "Google Artifact Registry location"
  type        = string
  default     = "us"
}

variable "gar_repository" {
  description = "Google Artifact Registry repository name"
  type        = string
  default     = "uf-internal"
}

variable "custom_image_name" {
  description = "Name for the custom runner image"
  type        = string
  default     = "arc-custom-runner"
}

variable "enable_custom_image" {
  description = "Whether to use a custom runner image from GAR (built via GitHub Actions) or fallback to default"
  type        = bool
  default     = true
}

variable "image_tag" {
  description = "Tag for the custom runner image. Use 'latest' for automatic builds or specify a version for rollback"
  type        = string
  default     = "latest"
}

variable "fallback_runner_image" {
  description = "Fallback runner image to use when enable_image_build is false"
  type        = string
  default     = "ghcr.io/actions/actions-runner:latest"
}

# --- GITHUB CONFIGURATION ---
variable "github_repository" {
  description = "The GitHub repository where the runners will be used"
  type        = string
}

variable "github_repository_full" {
  description = "The full GitHub repository in org/repo format for Workload Identity conditions"
  type        = string
  default     = ""
}

variable "github_pat" {
  description = "GitHub Personal Access Token - only used for bootstrapping if Secret Manager secret doesn't exist"
  type        = string
  sensitive   = true
  default     = ""
}

variable "arc_namespace" {
  description = "The Kubernetes namespace for GitHub Actions runners"
  type        = string
}

variable "controller_name" {
  description = "Name of the Actions Runner Controller"
  type        = string
}

# --- RUNNER SET CONFIGURATIONS ---
variable "runner_sets" {
  description = "Configuration for runner sets (light and heavy workloads)"
  type = map(object({
    runner_set_name                    = string
    pod_name                           = string
    min_runners                        = number
    max_runners                        = number
    runner_group                       = string
    pod_cpu_limit                      = string
    pod_memory_limit                   = string
    pod_cpu_request                    = string
    pod_memory_request                 = string
    pod_ephemeral_storage_limit        = string
    pod_ephemeral_storage_request      = string
    buildkit_ephemeral_storage_limit   = string
    buildkit_ephemeral_storage_request = string
    buildkit_cpu_limit                 = string
    buildkit_memory_limit              = string
    buildkit_cpu_request               = string
    buildkit_memory_request            = string
  }))
}

variable "display_name" {
  description = "Display name for the GCP service account"
  type        = string
}

variable "pat_name" {
  description = "Name of the Kubernetes secret for GitHub PAT"
  type        = string
}

variable "gcr_repo" {
  description = "GitHub Container Registry repository URL"
  type        = string
}

variable "gcr_controller_chart" {
  description = "Controller chart name in GCR"
  type        = string
}

variable "replicaCount" {
  description = "Number of controller replicas"
  type        = number
}

variable "gcr_runner_chart" {
  description = "Runner chart name in GCR"
  type        = string
}

variable "buildkit_pod_image" {
  description = "Container image for the BuildKit sidecar"
  type        = string
}