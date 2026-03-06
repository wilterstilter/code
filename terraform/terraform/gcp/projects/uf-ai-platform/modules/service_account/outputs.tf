output "service_account_member" {
  description = "The Service account's IDs and its member property"
  value = {
    for account_id, account in var.service_accounts :
    account_id => google_service_account.service_account[account_id].member
  }
}
