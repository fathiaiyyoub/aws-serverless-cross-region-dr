variable "primary_region" {
  description = "Primary AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

variable "secondary_region" {
  description = "Secondary AWS Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "domain_name" {
  description = "Registered domain name"
  type        = string
  default     = "fathiaiyyoub.com.au"
}

variable "api_subdomain" {
  description = "API custom domain name"
  type        = string
  default     = "api.fathiaiyyoub.com.au"
}