variable "firewall" {
  type        = list(map(string))
  description = "List of routes being created in this VPC"
}