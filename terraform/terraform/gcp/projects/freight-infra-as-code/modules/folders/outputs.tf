output "environment_folders" {
  value       = { for env, m in module.env_folders : env => m.folder.id }
  description = "A map with the environment as key and folder id as value"
}
