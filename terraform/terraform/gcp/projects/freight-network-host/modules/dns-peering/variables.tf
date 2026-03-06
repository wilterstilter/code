variable "dns_names" {
  description = "A list of DNS names for the peering zones (e.g., ['example.com.', 'transplace.com.'])"
  type        = list(string)
}

variable "source_network" {
  description = "The URL of the source network where the DNS peering zones will be created"
  type        = string
}

variable "target_network" {
  description = "The URL of the target network to which DNS queries will be forwarded"
  type        = string
}
