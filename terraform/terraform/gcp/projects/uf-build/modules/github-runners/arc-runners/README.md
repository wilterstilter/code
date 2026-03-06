# GitHub Actions Runner Controller (ARC) on GKE

This Terraform module deploys and configures GitHub Actions Runner Controller (ARC) on UF's Google Kubernetes Engine (GKE) 'gke-dev' cluster. The module sets up self-hosted GitHub Actions runners that automatically scale based on workflow demands and includes **automatic Docker image building and management** with **rootless BuildKit support** for secure container builds.

## Architecture Overview

The module implements the following components:

1. **Actions Runner Controller (ARC)**: A Kubernetes operator that manages runner pods
2. **Runner Scale Set**: Defines the pool of runners and their scaling behavior
3. **Automatic Image Building**: Uses Terraform Docker provider to build and push custom runner images
4. **Rootless BuildKit Sidecar**: Enables secure Docker-in-Docker builds without privileged containers
5. **Workload Identity**: Secure authentication between GKE and GitHub using GCP and Kubernetes Service Accounts
6. **Secret Manager Integration**: Automatic retrieval of GitHub PAT and service account keys
7. **Kubernetes Resources**: Namespace, Service Accounts, Secrets, and Image Pull Secrets management

## Prerequisites

- An existing GKE cluster
- GitHub Personal Access Token (PAT) with appropriate permissions stored in Secret Manager as `github-actions-pat`
- Service account key stored in Secret Manager as `sa-jenkins-nonprod-key` for GAR authentication
- Necessary GCP IAM permissions to create service accounts
- Docker runtime available where Terraform runs (for image building)
- Helm v3.x installed
- Existing Google Artifact Registry repository

## Features

- **Automatic Docker Image Building**: Builds and pushes custom runner images to Google Artifact Registry
- **Rootless BuildKit Integration**: Secure container builds using rootless BuildKit sidecar
- **Version Management**: Automatic tagging with both `:latest` and version-specific tags
- **Easy Rollbacks**: Simple version switching for deployments
- **Secret Manager Integration**: Automatic retrieval of sensitive data from Google Secret Manager
- **Automated scaling** of GitHub Actions runners with force updates
- **Secure secret management** for GitHub PAT and registry authentication
- **Configurable resource limits** and requests for runner pods
- **Workload Identity integration** for GCP authentication
- **Customizable runner groups** and labels
- **Security Hardening**: AppArmor and seccomp profiles for BuildKit containers

## Usage

```hcl
module "github_runners" {
  source = "./modules/github-runners/arc-runners"

  project_id         = "your-project-id"
  cluster_name      = "your-gke-cluster"
  location          = "us-central1"
  github_repository = "org/repo"
  
  # Container Registry Configuration
  gar_project_id    = "your-gar-project-id"
  gar_location      = "us"
  gar_repository    = "uf-internal"
  custom_image_name = "arc-custom-runner"
  enable_image_build = true        # Set to false to use fallback image
  image_tag         = "latest"     # Use "latest" or specify version for rollback
  
  # Runner Configuration
  arc_namespace    = "github-runners"
  controller_name  = "arc-controller"
  runner_set_name  = "arc-runner-set"
  
  # Scaling Configuration
  minRunners = 1
  maxRunners = 10
  
  # Runner Pod Resources
  pod_cpu_limit      = "2"
  pod_memory_limit   = "4Gi"
  pod_cpu_request    = "1"
  pod_memory_request = "2Gi"

  # BuildKit Configuration
  buildkit_pod_image = "moby/buildkit:v0.23.0-rootless"
}
```

## Docker Image Management

### Automatic Building
When `enable_image_build = true`, the module:
1. Builds a custom Docker image from the local `Dockerfile`
2. Tags it with the specified `image_tag` (e.g., `:latest` or `:v1.0.0`)
3. Pushes the image to Google Artifact Registry using OAuth2 authentication
4. Uses the tagged image in runner deployments with proper pull secrets

### Version Management & Rollbacks
To rollback to a previous version:
1. Find the version tag from GAR console or your version control
2. Set `image_tag = "v1.0.0"` (replace with actual version)
3. Run `terraform apply`

To disable automatic building:
1. Set `enable_image_build = false`
2. The module will use `fallback_runner_image` (defaults to official GitHub runner)

### Image Building Triggers
Images are rebuilt when:
- `Dockerfile` content changes
- `.dockerignore` content changes  
- `image_tag` variable changes (for rollbacks)

## BuildKit Rootless Configuration

The module includes a **rootless BuildKit sidecar** container for secure Docker builds:

### Security Features
- **Rootless execution**: Runs as user/group 1000 (non-root)
- **Seccomp profile**: Unconfined for container operations
- **AppArmor profile**: Unconfined for container operations
- **Socket communication**: Uses Unix socket for secure inter-container communication

### Container Configuration
```yaml
containers:
  - name: runner
    image: custom-runner-image
    env:
      - name: BUILDKIT_HOST
        value: "unix:///run/buildkit/buildkitd.sock"
    volumeMounts:
      - name: buildkit-socket
        mountPath: /run/buildkit
  
  - name: buildkitd
    image: moby/buildkit:v0.23.0-rootless
    command:
      - rootlesskit
      - buildkitd
      - --addr
      - unix:///run/buildkit/buildkitd.sock
      - --oci-worker-no-process-sandbox
    securityContext:
      runAsUser: 1000
      runAsGroup: 1000
      runAsNonRoot: true
```

## Module Components

### 1. Secret Manager Integration
- **GitHub PAT**: Automatically retrieves from `github-actions-pat` secret
- **Service Account Key**: Fetches `sa-jenkins-nonprod-key` for GAR authentication
- **Fallback Support**: Uses variable values for bootstrapping if secrets don't exist

### 2. Docker Image Building
- Uses Terraform Docker provider for building
- Automatic OAuth2 authentication with Google Artifact Registry
- Multi-platform support (linux/amd64)
- Content-based versioning for reproducibility

### 3. Namespace and Service Accounts

The module creates:
- A dedicated Kubernetes namespace for ARC
- A Google Service Account (GSA) for the runner controller
- A Kubernetes Service Account (KSA) linked to the GSA via Workload Identity
- Image pull secrets for Google Artifact Registry authentication

### 4. ARC Controller Deployment

Deploys the Actions Runner Controller using Helm with:
- Configurable replica count
- Service account integration
- Resource management
- Force updates when configuration changes

### 5. Runner Scale Set

Configures the runner pool with:
- Min/Max scaling limits
- Resource quotas
- Runner group assignment
- Container image specification
- BuildKit sidecar integration
- Shared volume for socket communication

## Required Variables

| Variable | Description | Type |
|----------|-------------|------|
| project_id | GCP Project ID | string |
| cluster_name | GKE cluster name | string |
| location | GKE cluster location | string |
| github_repository | GitHub repository (org/repo) | string |
| arc_namespace | Kubernetes namespace | string |
| controller_name | ARC controller name | string |
| runner_set_name | Runner set name | string |
| display_name | Display name for GCP service account | string |
| pat_name | Name of Kubernetes secret for GitHub PAT | string |
| gcr_repo | GitHub Container Registry repository URL | string |
| gcr_controller_chart | Controller chart name | string |
| gcr_runner_chart | Runner chart name | string |
| replicaCount | Number of controller replicas | number |
| pod_name | Name of the runner pod | string |
| buildkit_pod_image | BuildKit sidecar image | string |

## Optional Variables

| Variable | Description | Default |
|----------|-------------|---------|
| github_pat | GitHub PAT (for bootstrapping) | "" |
| gar_project_id | GAR project ID | "uf-build-p" |
| enable_image_build | Enable automatic image building | true |
| image_tag | Image tag (latest or version) | "latest" |
| gar_location | GAR location | "us" |
| gar_repository | GAR repository name | "uf-internal" |
| custom_image_name | Custom image name | "arc-custom-runner" |
| fallback_runner_image | Fallback when building disabled | "ghcr.io/actions/actions-runner:latest" |
| minRunners | Minimum number of runners | number |
| maxRunners | Maximum number of runners | number |
| pod_cpu_limit | CPU limit for runner pods | string |
| pod_memory_limit | Memory limit for runner pods | string |
| pod_cpu_request | CPU request for runner pods | string |
| pod_memory_request | Memory request for runner pods | string |
| runnerGroup | GitHub runner group name | string |

## Outputs

| Output | Description |
|--------|-------------|
| custom_runner_image | Full tag of the runner image being used |
| image_build_enabled | Whether automatic building is enabled |
| runner_set_name | Runner set name for workflows |
| kubernetes_host | GKE cluster endpoint |
| cluster_ca_certificate | Cluster CA certificate (sensitive) |
| runner_namespace | Kubernetes namespace for runners |

## Security Considerations

1. **GitHub PAT** is stored as a Kubernetes secret and retrieved from Secret Manager
2. **Workload Identity** is used for GCP authentication
3. **Resource limits** are enforced on runner pods
4. **Service account permissions** are minimized
5. **Image building** happens in isolated Docker context
6. **Rootless BuildKit** prevents privilege escalation
7. **Security profiles** (seccomp, AppArmor) are applied to BuildKit containers
8. **Image pull secrets** use service account keys from Secret Manager

## Version Management Examples

### Deploy Latest Version
```hcl
enable_image_build = true
image_tag         = "latest"
```

### Rollback to Specific Version  
```hcl
enable_image_build = true
image_tag         = "v1.0.0"  # Use actual version tag
```

### Use Official GitHub Runner
```hcl
enable_image_build = false
# Will use fallback_runner_image
```

## Monitoring and Maintenance

Monitor the following:
- **Image build status** in Terraform output
- **Runner pod status** and scaling events
- **BuildKit sidecar** logs and socket connectivity
- **Resource utilization** for both runner and BuildKit containers
- **GitHub Actions workflow** execution
- **Controller logs** for troubleshooting
- **Secret Manager** access and key rotation

## Troubleshooting

Common issues and solutions:

1. **Image build failures**:
   - Check Docker daemon is running
   - Verify GAR authentication and OAuth2 token
   - Review Dockerfile syntax
   - Check service account permissions in Secret Manager

2. **Runners not scaling**:
   - Check controller logs for errors
   - Verify GitHub PAT permissions in Secret Manager
   - Check resource quotas and limits
   - Ensure force_update is working correctly

3. **Authentication issues**:
   - Verify Workload Identity setup
   - Check service account permissions
   - Validate GitHub PAT in Secret Manager
   - Confirm image pull secret configuration

4. **BuildKit connection issues**:
   - Check BuildKit sidecar logs
   - Verify socket volume mounts
   - Confirm BUILDKIT_HOST environment variable
   - Check security context settings

5. **Version rollback issues**:
   - Ensure version tag exists in GAR
   - Check image_tag format and accessibility
   - Verify registry permissions and pull secrets
   - Confirm service account key is valid

6. **Secret Manager access**:
   - Verify secret names: `github-actions-pat`, `sa-jenkins-nonprod-key`
   - Check IAM permissions for Secret Manager access
   - Confirm secrets exist in the correct projects

## Relevant external documentation:
https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/about-actions-runner-controller

https://docs.github.com/en/enterprise-cloud@latest/admin/managing-github-actions-for-your-enterprise/getting-started-with-github-actions-for-your-enterprise/getting-started-with-self-hosted-runners-for-your-enterprise

https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release

https://github.com/moby/buildkit#rootless-mode

https://cloud.google.com/secret-manager/docs


## Contributing

When contributing to this module:
1. **Update documentation** for any new variables
2. **Test image building** and deployment
3. **Verify version management** works correctly
4. **Test BuildKit rootless functionality**
5. **Update troubleshooting guides**
6. **Test rollback scenarios**
7. **Validate Secret Manager integration**