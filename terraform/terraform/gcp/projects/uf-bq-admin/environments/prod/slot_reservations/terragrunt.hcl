include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../modules/slot_reservations"
}


# Inputs for the terragrunt configuration
inputs = {
  project_id = include.gcp.locals.project_id
  location   = "us-south1"

  reservations = [
    {
      name          = "uf-us-south1-query-dev"
      slot_capacity = 0
      edition       = "ENTERPRISE"
      max_slots     = 300
      assignments = [
        {
          assignee = "projects/uf-data-warehouse-d"
          job_type = "QUERY"
        },
        {
          assignee = "projects/uf-etl-d"
          job_type = "QUERY"
        }
      ]
    },
    {
      name          = "uf-us-south1-query-nonprod"
      slot_capacity = 0
      edition       = "ENTERPRISE"
      max_slots     = 500
      assignments = [
        {
          assignee = "projects/uf-data-warehouse-n"
          job_type = "QUERY"
        },
        {
          assignee = "projects/uf-etl-n"
          job_type = "QUERY"
        }
      ]
    },
    {
      name          = "uf-us-south1-query-prod"
      slot_capacity = 0
      edition       = "ENTERPRISE"
      max_slots     = 600
      assignments = [
        {
          assignee = "projects/uf-data-warehouse-p"
          job_type = "QUERY"
        },
        {
          assignee = "projects/uf-etl-p"
          job_type = "QUERY"
        },
        {
          assignee = "projects/uf-bq-admin-p"
          job_type = "QUERY"
        }
      ]
    },
    {
      name          = "uf-us-south1-consumer-query" 
      slot_capacity = 0
      edition       = "ENTERPRISE"
      max_slots     = 200
      assignments = [
        {
          assignee = "projects/uf-data-analysis"
          job_type = "QUERY"
        }
      ]
    },
    {
      name          = "uf-us-south1-background-dev"
      slot_capacity = 0
      edition       = "ENTERPRISE"
      max_slots     = 50
      assignments = [
        {
          assignee = "projects/uf-data-warehouse-d"
          job_type = "BACKGROUND"
        }
      ]
    },
    {
      name          = "uf-us-south1-background-nonprod"
      slot_capacity = 0
      edition       = "ENTERPRISE"
      max_slots     = 50
      assignments = [
        {
          assignee = "projects/uf-data-warehouse-n"
          job_type = "BACKGROUND"
        }
      ]
    },
    {
      name          = "uf-us-south1-background-prod"
      slot_capacity = 0
      edition       = "ENTERPRISE"
      max_slots     = 50
      assignments = [
        {
          assignee = "projects/uf-data-warehouse-p"
          job_type = "BACKGROUND"
        }
      ]
    }
  ]
}
