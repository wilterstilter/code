include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/freight-infra-as-code/modules/projects"
}

dependency "folders" {
  config_path = "../folders"
}

dependency "iam" {
    config_path = "../iam"
}

inputs = {
	iac_project_id = include.gcp.locals.project_id
	organization_id = include.gcp.locals.organization_id
	environment_folders = dependency.folders.outputs.environment_folders
	entitlements = [
		{
			entitlement_id = "project-reader"
			role_bindings  = [
				dependency.iam.outputs.role_global_reader_id
			]
		},
		{
			entitlement_id = "project-secrets-viewier"
			role_bindings  = [
				dependency.iam.outputs.role_global_secret_viewer_id
			]
		},
		{
			entitlement_id = "project-emergency-admin"
			role_bindings  = [
				"roles/compute.admin",
				"roles/compute.networkAdmin",
				"roles/compute.instanceAdmin",
				"roles/cloudkms.admin",
				"roles/storage.admin",
				"roles/pubsub.admin",
				"roles/logging.admin",
				"roles/monitoring.admin",
				"roles/cloudfunctions.admin",
				"roles/bigquery.admin",
				"roles/serviceusage.serviceUsageAdmin",
				"roles/cloudsql.admin",
				"roles/container.admin",
				"roles/container.clusterAdmin",
				"roles/dataflow.admin",
				"roles/cloudfunctions.developer",
				"roles/run.admin",
				"roles/iam.serviceAccountAdmin",
				"roles/iam.securityAdmin",
				"roles/securitycenter.admin"
			]
		}
	]
	gcp_projects = [
		{
			id    = "freight-infra-as-code"
			layer = "core"
			team  = "platform"
			environments = [
				{
					name           = "prod"
					monthly_budget = 1500
					overrides = {
						project_id = "freight-infra-as-code"
					}
				}
			]
			activate_apis = [
				"iam.googleapis.com",
				"cloudresourcemanager.googleapis.com",
				"serviceusage.googleapis.com",
				"secretmanager.googleapis.com",
				"billingbudgets.googleapis.com",
				"accesscontextmanager.googleapis.com",
				"monitoring.googleapis.com", # Activated extra APIs for Datadog monitoring (https://docs.datadoghq.com/integrations/google_cloud_platform/?tab=project#prerequisites)
				"cloudasset.googleapis.com",
				"logging.googleapis.com",
				"dataflow.googleapis.com",
				"pubsub.googleapis.com",
				"cloudkms.googleapis.com", # Added for Vault KMS auto-unseal support
				"servicenetworking.googleapis.com",
				"sqladmin.googleapis.com"
			]
		},
		{
			id    = "uf-data-warehouse"
			layer = "platform"
			team  = "data-platform"
			environments = [
				{
					name           = "dev"
					monthly_budget = 1000
				},
				{
					name           = "nonprod"
					monthly_budget = 1000
				},
				{
					name           = "prod"
					monthly_budget = 5000
					shared_vpc_subnets = [
						"projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-kafka-connect",
						"projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-composer-network"
					]
				}
			]
			activate_apis = [
				"bigqueryconnection.googleapis.com",
				"bigquerydatatransfer.googleapis.com",
				"bigquerymigration.googleapis.com",
				"bigqueryreservation.googleapis.com",
				"bigquerystorage.googleapis.com",
				"cloudfunctions.googleapis.com",
				"composer.googleapis.com",
				"connectors.googleapis.com",
				"datalineage.googleapis.com",
				"dataplex.googleapis.com",
				"monitoring.googleapis.com",
				"secretmanager.googleapis.com",
				"storage.googleapis.com"
			]
		},
		{
			id    = "freight-interconnects"
			layer = "core"
			team  = "network"
			environments = [
				{
					name           = "prod"
					monthly_budget = 5000
					overrides = {
						project_id    = "freight-interconnects"
					}
				}
			]
			additional_labels = {
				"is_imported" = "true"
			}
			activate_apis = [
				"cloudasset.googleapis.com"
			],
		},
		{
			id    = "freight-byoip"
			layer = "core"
			team  = "network"
			environments = [
				{
					name           = "prod"
					monthly_budget = 100
					overrides = {
						project_id    = "freight-byoip"
					}
				}
			]
			additional_labels = {
				"is_imported" = "true"
			}
		},
		{
			id    = "freight-domains"
			layer = "core"
			team  = "network"
			environments = [
				{
					name           = "prod"
					monthly_budget = 250
				}
			]
			additional_labels = {
				"is_imported" = "true"
			}
			activate_apis = [
				"dns.googleapis.com",
			]
		},
		{
			id    = "uf-cloud-workstations"
			layer = "platform"
			team  = "network"
			environments = [
				{
					name           = "prod"
					monthly_budget = 1000
					shared_vpc_subnets = [
						"projects/freight-network-host-p/regions/us-east4/subnetworks/us-east4-cloud-workstations-s1"
					]
				}
			]
			additional_labels = {
				"is_intranet" = "true"
			}
			activate_apis = [
				"secretmanager.googleapis.com",
				"workstations.googleapis.com",
				"dns.googleapis.com"
			]
		},
		{
			id    = "harding-sandbox"
			layer = "product"
			team  = "network"
			environments = [
				{
					name           = "prod"
					monthly_budget = 2000
					overrides = {
						project_id    = "harding-sandbox"
					}
				}
			]
			additional_labels = {
				"is_imported" = "true"
			}
		},
		{
			id    = "api-7454232358621519384"
			layer = "product"
			team  = "mobile"
			environments = [
				{
					name           = "prod"
					monthly_budget = 100
					overrides = {
						project_id    = "api-7454232358621519384-686003"
						project_name  = "google-play-android-developer"
					}
				}
			]
			additional_labels = {
				"is_imported" = "true"
			}
		},
		{
			id    = "ardent-girder-245515"
			layer = "product"
			team  = "mobile"
			environments = [
				{
					name           = "prod"
					monthly_budget = 100
					overrides = {
						project_id    = "ardent-girder-245515"
						project_name  = "location-validator"
					}
				}
			]
			additional_labels = {
				"is_imported" = "true"
			}
		},
		{
			id    = "freight-workspace-logs"
			layer = "product"
			team  = "mobile"
			environments = [
				{
					name           = "prod"
					monthly_budget = 100
					overrides = {
						project_id    = "freight-workspace-logs"
					}
				}
			]
			additional_labels = {
				"is_imported" = "true"
			}
		},
		{
			id    = "tms-mobile-306015"
			layer = "product"
			team  = "mobile"
			environments = [
				{
					name           = "prod"
					monthly_budget = 100
					overrides = {
						project_id    = "tms-mobile-306015"
						project_name  = "tms-mobile"
					}
				}
			]
			additional_labels = {
				"is_imported" = "true"
			}
		},
		{
			id    = "tms-mobile-app-a1f87"
			layer = "product"
			team  = "mobile"
			environments = [
				{
					name           = "prod"
					monthly_budget = 100
					overrides = {
						project_id    = "tms-mobile-app-a1f87"
						project_name  = "tms-mobile-app"
					}
				},
			]
			additional_labels = {
				"is_imported" = "true"
				"firebase"    = "enabled"
			}
		},
		{
			id    = "smart-bloom-294513"
			layer = "product"
			team  = "mobile"
			environments = [
				{
					name           = "prod"
					monthly_budget = 3000
					overrides = {
						project_id    = "smart-bloom-294513"
						project_name  = "api-for-maps"
					}
				}
			]
			additional_labels = {
				"is_imported" = "true"
			}
		},
		{
			id    = "tms-mobile-app-dev"
			layer = "product"
			team  = "mobile"
			environments = [
				{
					name        = "dev"
					overrides = {
						project_id    = "tms-mobile-app-dev"
						project_name  = "tms-mobile-app-dev"
					}
				}
			]
			additional_labels = {
				"is_imported" = "true"
				"firebase"    = "enabled"
			}
		},
		{
			id    = "freight-network-host"
			layer = "core"
			team  = "network"
			environments = [
				{
					name           = "prod"
					monthly_budget = 1000
				},
				{
					name           = "nonprod"
					monthly_budget = 300
				},
				{
					name           = "dev"
					monthly_budget = 300
				}
			],
			activate_apis = [
				"dns.googleapis.com",
				"servicedirectory.googleapis.com",
				"servicenetworking.googleapis.com",
				"networkconnectivity.googleapis.com",
				"certificatemanager.googleapis.com",
				"compute.googleapis.com",
				"container.googleapis.com",
				"mesh.googleapis.com",
				"cloudresourcemanager.googleapis.com",
				"vpcaccess.googleapis.com"
			]
		},
		{
			id    = "uf-change-data-capture"
			layer = "platform"
			team  = "data-platform"
			environments = [
				{
					name           = "nonprod"
					monthly_budget = 1000
				},
				{
					name           = "prod"
					monthly_budget = 1000
				},
			]
			activate_apis = [
				"bigqueryconnection.googleapis.com",
				"bigquerydatatransfer.googleapis.com",
				"bigquerymigration.googleapis.com",
				"bigqueryreservation.googleapis.com",
				"bigquerystorage.googleapis.com",
				"cloudfunctions.googleapis.com",
				"connectors.googleapis.com",
				"datacatalog.googleapis.com",
				"datalineage.googleapis.com",
				"secretmanager.googleapis.com"
			]
		},
		{
			id    = "uf-fintech-doc-automation"
			layer = "product"
			team  = "fintech"
			environments = [
				{
					name           = "dev"
					monthly_budget = 3000
				},
				{
					name           = "prod"
					monthly_budget = 30000
				}
			]
			activate_apis = [
				"documentai.googleapis.com",
				"secretmanager.googleapis.com",
				"aiplatform.googleapis.com",
				"storage-component.googleapis.com",
				"run.googleapis.com",
				"iap.googleapis.com",
				"artifactregistry.googleapis.com",
				"cloudbuild.googleapis.com",
				"logging.googleapis.com",
				"dataform.googleapis.com"
			]
		},
		{
			id    = "uf-insights-ai"
			layer = "product"
			team  = "mle"
			environments = [
				{
					name           = "dev"
					monthly_budget = 1000
				}
			]
			activate_apis = [
				"aiplatform.googleapis.com",
				"storage-component.googleapis.com",
				"secretmanager.googleapis.com",
			]
		},
		{
			id    = "uf-ai-platform"
			layer = "product"
			team  = "mle"
			environments = [
				{
					name           = "dev"
					monthly_budget = 3000
				}
			]
			activate_apis = [
				"aiplatform.googleapis.com",
				"storage-component.googleapis.com",
				"secretmanager.googleapis.com",
			]
		},
		{
			id    = "uf-network-team"
			layer = "core"
			team  = "network"
			environments = [
				{
					name           = "prod"
					monthly_budget = 20
				}
			]
		},
		{
			id    = "uf-build"
			layer = "core"
			team  = "platform"
			environments = [
				{
					name           = "prod"
					monthly_budget = 1000
					shared_vpc_subnets = [
						"projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-github-runners"
					]
				}
			]
			activate_apis = [
				"cloudasset.googleapis.com",
				"artifactregistry.googleapis.com",
				"containeranalysis.googleapis.com",
				"secretmanager.googleapis.com",
				"logging.googleapis.com",
				"monitoring.googleapis.com",
				"iam.googleapis.com",
				"container.googleapis.com",
				"iamcredentials.googleapis.com",
				"run.googleapis.com",
				"artifactregistry.googleapis.com",
				"storage.googleapis.com",
				"cloudresourcemanager.googleapis.com",
				"vpcaccess.googleapis.com"
			],
		},
		{
			id    = "uf-codelab"
			layer = "core"
			team  = "platform"
			environments = [
				{
					name           = "dev"
					monthly_budget = 10
				}
			]
			activate_apis = [
				"storage.googleapis.com"
			]
		},
		{
			id    = "uf-edge"
			layer = "core"
			team  = "network"
			environments = [
				{
					name                 = "prod"
					monthly_budget       = 2000
					shared_vpc_no_subnet = true
				},
				{
					name                 = "nonprod"
					monthly_budget       = 2000
					shared_vpc_no_subnet = true
				},
				{
					name                 = "dev"
					monthly_budget       = 1000
					shared_vpc_no_subnet = true
				}
			]
			activate_apis = [
				"compute.googleapis.com",
				"networkconnectivity.googleapis.com",
				"certificatemanager.googleapis.com"
			]
		},
		{
			id    = "uf-compute"
			layer = "core"
			team  = "platform"
			environments = [
				{
					name           = "dev"
					monthly_budget = 2500
					shared_vpc_subnets = [
						"projects/freight-network-host-d/regions/us-south1/subnetworks/us-south1-gke-dev",
						"projects/freight-network-host-d/regions/us-east4/subnetworks/us-east4-gke-dev-ptms"
					]
				},
				{
					name           = "nonprod"
					monthly_budget = 3000
					shared_vpc_subnets = [
						"projects/freight-network-host-n/regions/us-south1/subnetworks/us-south1-gke-nonprod",
						"projects/freight-network-host-n/regions/us-south1/subnetworks/us-south1-gke-nonprod-ptms-south1",
						"projects/freight-network-host-n/regions/us-east4/subnetworks/us-east4-gke-nonprod-ptms-east4"
					]
				},
				{
					name           = "prod"
					monthly_budget = 3000
					shared_vpc_subnets = [
						"projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-gke-poc",
						"projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-gke-prod-ptms-south1",
						"projects/freight-network-host-p/regions/us-east4/subnetworks/us-east4-gke-prod-ptms-east4"
					]
				}
			]
			activate_apis = [
				"container.googleapis.com",
				"compute.googleapis.com",
				"gkehub.googleapis.com",
				"container.googleapis.com",
				"gkebackup.googleapis.com",
				"anthos.googleapis.com",
				"meshconfig.googleapis.com",
				"meshca.googleapis.com",
				"meshtelemetry.googleapis.com",
				"iam.googleapis.com",
				"storage.googleapis.com",
				"iamcredentials.googleapis.com",
				"anthosconfigmanagement.googleapis.com",
				"mesh.googleapis.com",
				"cloudresourcemanager.googleapis.com",
				"file.googleapis.com",
				"run.googleapis.com",
				"artifactregistry.googleapis.com",
				"secretmanager.googleapis.com"
			]
		},
		{
  			id    = "uf-logging"
  			layer = "core"
  			team  = "platform"
  			environments = [
    			{
      				name           = "prod"
      				monthly_budget = 1000
					shared_vpc_subnets = [
						"projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-dataflow-logging"
					]
    			}
  			]
  			activate_apis = [
				"logging.googleapis.com",
				"pubsub.googleapis.com",
				"dataflow.googleapis.com",
				"iamcredentials.googleapis.com",
				"monitoring.googleapis.com",
				"secretmanager.googleapis.com"
  			]
		},
		{
			id    = "uf-cameyo"
			layer = "core"
			team  = "platform"
			environments = [
				{
					name           = "prod"
					monthly_budget = 500
					shared_vpc_subnets = [
						"projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-cameyo"
					]
					shared_vpc_users = [
						"bring-your-own-cloud-sa"
					]
				}
			]
			activate_apis = [
				"secretmanager.googleapis.com"
			]
		},
		{
			id	= "uf-infosec"
			layer = "product"
			team	= "infosec"
			environments	= [
				{
					name	= "prod"
					monthly_budget	= 50
				}
			]
			activate_apis	= [
				"securitycenter.googleapis.com",
				"cloudasset.googleapis.com",
				"iam.googleapis.com",
				"secretmanager.googleapis.com",
				"cloudasset.googleapis.com",
				"cloudresourcemanager.googleapis.com",
				"appengine.googleapis.com",
				"sqladmin.googleapis.com",
				"compute.googleapis.com",
				"logging.googleapis.com",
				"firebase.googleapis.com",
				"cloudfunctions.googleapis.com"
			]
		},
		{
			id    = "uf-etl"
			layer = "platform"
			team  = "data-platform"
			environments = [
				{
					name           = "dev"
					monthly_budget = 1000
					shared_vpc_subnets = [
						"projects/freight-network-host-d/regions/us-south1/subnetworks/us-south1-composer-network-d"
					]
				},
				{
					name           = "nonprod"
					monthly_budget = 1000
					shared_vpc_subnets = [
						"projects/freight-network-host-n/regions/us-south1/subnetworks/us-south1-composer-network-n"
					]
				},
				{
					name           = "prod"
					monthly_budget = 5000
					shared_vpc_subnets = [
						"projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-composer-network"
					]
				}
			]
			activate_apis = [
				"bigqueryconnection.googleapis.com",
				"bigquerydatatransfer.googleapis.com",
				"bigquerymigration.googleapis.com",
				"bigqueryreservation.googleapis.com",
				"bigquerystorage.googleapis.com",
				"bigquery.googleapis.com",
				"cloudfunctions.googleapis.com",
				"cloudresourcemanager.googleapis.com",
				"composer.googleapis.com",
				"connectors.googleapis.com",
				"datacatalog.googleapis.com",
				"datalineage.googleapis.com",
				"monitoring.googleapis.com",
				"secretmanager.googleapis.com",
				"storage.googleapis.com"
			]
		},
        {
			id    = "uf-csaw-workshop"
			layer = "product"
			team  = "mle"
			environments = [
				{
					name           = "dev"
					monthly_budget = 5000
				}
			]
			activate_apis = [
				"aiplatform.googleapis.com",
				"artifactregistry.googleapis.com",
				"bigquery.googleapis.com",
				"bigqueryconnection.googleapis.com",
				"bigquerymigration.googleapis.com",
				"bigquerystorage.googleapis.com",
				"cloudbuild.googleapis.com",
				"cloudfunctions.googleapis.com",
				"cloudresourcemanager.googleapis.com",
				"composer.googleapis.com",
				"datacatalog.googleapis.com",
				"dataflow.googleapis.com",
				"dataform.googleapis.com",
				"dataplex.googleapis.com",
				"documentai.googleapis.com",
				"language.googleapis.com",
				"logging.googleapis.com",
				"notebooks.googleapis.com",
				"orgpolicy.googleapis.com",
				"pubsub.googleapis.com",
				"run.googleapis.com",
				"secretmanager.googleapis.com",
				"sqladmin.googleapis.com",
				"storage-component.googleapis.com",
				"storage.googleapis.com",
				"texttospeech.googleapis.com",
				"visionai.googleapis.com",
				"vpcaccess.googleapis.com"
			]
		},
		{
			id    = "uf-bq-admin"
			layer = "platform"
			team  = "data-platform"
			environments	= [
				{
					name	= "prod"
					monthly_budget	= 5000
				}
			]
			activate_apis	= [
				"bigqueryconnection.googleapis.com",
				"bigquerydatatransfer.googleapis.com",
				"bigquerymigration.googleapis.com",
				"bigqueryreservation.googleapis.com",
				"bigquerystorage.googleapis.com",
				"bigquery.googleapis.com",
				"cloudfunctions.googleapis.com",
				"cloudresourcemanager.googleapis.com",
				"connectors.googleapis.com",
				"datacatalog.googleapis.com",
				"datalineage.googleapis.com",
				"monitoring.googleapis.com",
				"recommender.googleapis.com",
				"secretmanager.googleapis.com",
				"storage.googleapis.com"
			]
		},
		{
			id    = "uf-apigee-support"
			layer = "core"
			team  = "platform"
			environments = [
				{
					name           = "dev"
					monthly_budget = 100
				}
			]
			additional_labels = {
				"is_imported" = "true"
			}
			activate_apis = [
				"apigee.googleapis.com"
			],
		},
		{
			id    = "uf-data-analysis"
			layer = "platform"
			team  = "data-platform"
			environments = [
				{
					name           = "prod"
					monthly_budget = 5000
					overrides = {
						project_id = "uf-data-analysis"
					}
					shared_vpc_subnets = [
						"projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-datafusion-network"
					]
				}
			]
			activate_apis	= [
				"bigqueryconnection.googleapis.com",
				"bigquerydatatransfer.googleapis.com",
				"bigquerymigration.googleapis.com",
				"bigqueryreservation.googleapis.com",
				"bigquerystorage.googleapis.com",
				"bigquery.googleapis.com",
				"cloudfunctions.googleapis.com",
				"cloudresourcemanager.googleapis.com",
				"connectors.googleapis.com",
				"datacatalog.googleapis.com",
				"datalineage.googleapis.com",
				"secretmanager.googleapis.com",
				"storage.googleapis.com",
				"datafusion.googleapis.com",
				"dataproc.googleapis.com",
				"servicenetworking.googleapis.com",
				"notebooks.googleapis.com",
			]
		},
		{
			id    = "uf-database"
			layer = "platform"
			team  = "data-platform"
			environments	= [
				{
					name                 = "dev"
					monthly_budget       = 1000
					shared_vpc_no_subnet = true  # Attach to Shared VPC for PSA
				},
				{
					name                 = "nonprod"
					monthly_budget       = 5000
					shared_vpc_no_subnet = true  # Attach to Shared VPC for PSA
				},
				{
					name                 = "prod"
					monthly_budget       = 5000
					shared_vpc_no_subnet = true  # Attach to Shared VPC for PSA
				}
			]
			activate_apis	= [
				"sqladmin.googleapis.com",
				"compute.googleapis.com",
				"servicenetworking.googleapis.com",
				"secretmanager.googleapis.com",
				"dns.googleapis.com"  # Added for Cloud SQL write endpoint DNS
			]
		},
		{
			id    = "uf-optimize"
			layer = "product"
			team  = "optimization"
			environments = [
				{
					name           = "dev"
					monthly_budget = 3000
				}
			]
			activate_apis = [
				"aiplatform.googleapis.com",
				"secretmanager.googleapis.com"
			]
		},
		{
			id    = "uf-vertex-ai-suite"
			layer = "platform"
			team  = "data-platform"
			environments	= [
				{
					name           = "prod"
					monthly_budget = 5000
					shared_vpc_subnets = [
						"projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-vertex-ai-network"
					]
				}
			]
			activate_apis	= [
				"compute.googleapis.com",
				"aiplatform.googleapis.com",
				"artifactregistry.googleapis.com",
				"cloudscheduler.googleapis.com",
				"notebooks.googleapis.com",
				"cloudaicompanion.googleapis.com",
				"storage.googleapis.com",
				"secretmanager.googleapis.com",
				"logging.googleapis.com",
				"dataform.googleapis.com",
				"dataproc.googleapis.com",
				"bigquerydatatransfer.googleapis.com",
				"generativelanguage.googleapis.com",
				"container.googleapis.com",
				"dns.googleapis.com",
				"cloudfunctions.googleapis.com",
				"dataplex.googleapis.com",
				"storage-component.googleapis.com",
			]
		},
		{
			id    = "uf-ai-poc"
			layer = "product"
			team  = "ai-poc"
			environments = [
				{
					name           = "dev"
					monthly_budget = 3000
				},
				{
					name           = "prod"
					monthly_budget = 30000
				}
			]
			activate_apis = [
				"aiplatform.googleapis.com",
				"artifactregistry.googleapis.com",
				"bigquery.googleapis.com",
				"bigqueryconnection.googleapis.com",
				"bigquerymigration.googleapis.com",
				"bigquerystorage.googleapis.com",
				"cloudbuild.googleapis.com",
				"cloudfunctions.googleapis.com",
				"cloudresourcemanager.googleapis.com",
				"composer.googleapis.com",
				"datacatalog.googleapis.com",
				"dataflow.googleapis.com",
				"dataform.googleapis.com",
				"dataplex.googleapis.com",
				"documentai.googleapis.com",
				"language.googleapis.com",
				"logging.googleapis.com",
				"notebooks.googleapis.com",
				"orgpolicy.googleapis.com",
				"pubsub.googleapis.com",
				"run.googleapis.com",
				"secretmanager.googleapis.com",
				"sqladmin.googleapis.com",
				"storage-component.googleapis.com",
				"storage.googleapis.com",
				"texttospeech.googleapis.com",
				"visionai.googleapis.com",
				"iap.googleapis.com",
				"contactcenterinsights.googleapis.com",
				"ces.googleapis.com"
			]
		},
	]
}
