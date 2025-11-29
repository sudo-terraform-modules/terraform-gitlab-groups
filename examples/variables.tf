# ==============================================================================
# TERRAFORM VARIABLES FOR GITLAB GROUPS
# ==============================================================================
# This file contains variable definitions needed for the GitLab provider
# and any customizations for the group configurations.
# ==============================================================================

# GITLAB PROVIDER CONFIGURATION
# =============================

variable "gitlab_token" {
  description = "GitLab personal access token or project access token"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.gitlab_token) > 0
    error_message = "GitLab token cannot be empty."
  }
}

variable "gitlab_base_url" {
  description = "GitLab base URL (for self-hosted GitLab instances)"
  type        = string
  default     = "https://gitlab.com/api/v4/"

  validation {
    condition     = can(regex("^https?://", var.gitlab_base_url))
    error_message = "GitLab base URL must start with http:// or https://."
  }
}

# ORGANIZATION SETTINGS
# ====================

variable "organization_name" {
  description = "Name of your organization (used in group descriptions)"
  type        = string
  default     = "Your Organization"
}

variable "company_email_domain" {
  description = "Primary email domain for your company (used in email restrictions)"
  type        = string
  default     = "example.com"

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\\.[a-zA-Z]{2,}$", var.company_email_domain))
    error_message = "Company email domain must be a valid domain name."
  }
}

variable "enable_security_features" {
  description = "Enable advanced security features (2FA, push rules, etc.)"
  type        = bool
  default     = true
}

variable "default_visibility" {
  description = "Default visibility level for groups"
  type        = string
  default     = "private"

  validation {
    condition     = contains(["private", "internal", "public"], var.default_visibility)
    error_message = "Default visibility must be private, internal, or public."
  }
}

# CI/CD CONFIGURATION
# ==================

variable "shared_runners_minutes_limit" {
  description = "Default shared runners minutes limit for groups"
  type        = number
  default     = 10000

  validation {
    condition     = var.shared_runners_minutes_limit >= 0
    error_message = "Shared runners minutes limit must be >= 0."
  }
}

variable "enable_auto_devops" {
  description = "Enable Auto DevOps by default for groups"
  type        = bool
  default     = false
}

# SECURITY SETTINGS
# ================

variable "require_2fa_for_secure_groups" {
  description = "Require two-factor authentication for security-sensitive groups"
  type        = bool
  default     = true
}

variable "allowed_ip_ranges" {
  description = "List of allowed IP ranges for restricted groups (empty for no restrictions)"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for range in var.allowed_ip_ranges : can(cidrhost(range, 0))
    ])
    error_message = "All IP ranges must be valid CIDR blocks."
  }
}