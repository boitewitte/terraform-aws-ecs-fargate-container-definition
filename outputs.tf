output "is_valid" {
  value = local.is_valid
  description = "Provided configuration is valid"
}

output "enabled" {
  value = var.enabled
  description = "Module is enabled"
}

output "json" {
  value = local.is_valid == true ? local.json : ""
  description = "JSON containing Container Definition"
}

# output "definition" {
#   value = local.is_valid == true ? local.definition : {}
#   description = "Container Definition Object"
# }
