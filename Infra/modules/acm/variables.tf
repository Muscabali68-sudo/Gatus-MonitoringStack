# Name tag applied to the certificate
variable "certificate_name" {
  description = "Name tag applied to the ACM certificate"
  type        = string
}

# Domain protected by the certificate
variable "domain_name" {
  description = "Domain name protected by the ACM certificate"
  type        = string
}

# Method used to prove domain ownership
variable "validation_method" {
  description = "Method used to validate the ACM certificate"
  type        = string
}

# Encryption algorithm used by the certificate
variable "key_algorithm" {
  description = "Key algorithm used by the ACM certificate"
  type        = string
}

# Hosted zone where the validation record is created
variable "hosted_zone_id" {
  description = "ID of the Route 53 hosted zone"
  type        = string
}

# Time that DNS resolvers can cache the validation record
variable "validation_record_ttl" {
  description = "TTL for the ACM validation DNS record"
  type        = number
}