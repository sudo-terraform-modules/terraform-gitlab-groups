# REQUIRED VARIABLES
# ==================

variable "name" {
  description = "The name of the GitLab group."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "Group name cannot be empty."
  }
}

variable "path" {
  description = "The path of the GitLab group. This will be the URL slug for the group."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.path))
    error_message = "Group path must contain only alphanumeric characters, underscores, hyphens, and periods."
  }
}

# BASIC CONFIGURATION VARIABLES
# =============================

variable "description" {
  description = "A description of the GitLab group."
  type        = string
  default     = null
}

variable "default_branch" {
  description = "The default branch name for new projects in this group."
  type        = string
  default     = null
}

variable "parent_id" {
  description = "The ID of the parent group (creates a nested group). Leave null for top-level groups."
  type        = number
  default     = null
}

# VISIBILITY AND ACCESS CONTROL
# =============================

variable "visibility_level" {
  description = "The visibility level of the group. Valid values: private, internal, public."
  type        = string
  default     = "private"

  validation {
    condition     = contains(["private", "internal", "public"], var.visibility_level)
    error_message = "Visibility level must be one of: private, internal, public."
  }
}

variable "request_access_enabled" {
  description = "Allow users to request member access to the group."
  type        = bool
  default     = true
}

variable "membership_lock" {
  description = "Prevent users from being added to projects in this group."
  type        = bool
  default     = false
}

variable "share_with_group_lock" {
  description = "Prevent sharing projects with other groups within this group."
  type        = bool
  default     = false
}

variable "prevent_forking_outside_group" {
  description = "Prevent users from forking projects from this group to external namespaces."
  type        = bool
  default     = false
}

# CREATION PERMISSIONS
# ===================

variable "project_creation_level" {
  description = "Determine who can create projects in the group. Valid values: noone, owner, maintainer, developer, administrator."
  type        = string
  default     = "maintainer"

  validation {
    condition     = contains(["noone", "owner", "maintainer", "developer", "administrator"], var.project_creation_level)
    error_message = "Project creation level must be one of: noone, owner, maintainer, developer, administrator."
  }
}

variable "subgroup_creation_level" {
  description = "Determine who can create subgroups. Valid values: owner, maintainer."
  type        = string
  default     = "owner"

  validation {
    condition     = contains(["owner", "maintainer"], var.subgroup_creation_level)
    error_message = "Subgroup creation level must be one of: owner, maintainer."
  }
}

# EMAIL AND NOTIFICATION SETTINGS
# ===============================

variable "emails_enabled" {
  description = "Enable email notifications for the group."
  type        = bool
  default     = true
}

variable "mentions_disabled" {
  description = "Disable the capability of the group from getting mentioned."
  type        = bool
  default     = false
}

variable "allowed_email_domains_list" {
  description = "A list of email address domains allowed for group access."
  type        = list(string)
  default     = []
}

# FEATURES AND INTEGRATIONS
# =========================

variable "lfs_enabled" {
  description = "Enable Large File Storage (LFS) for projects in this group."
  type        = bool
  default     = true
}

variable "auto_devops_enabled" {
  description = "Enable Auto DevOps pipeline for all projects within this group."
  type        = bool
  default     = null
}

variable "wiki_access_level" {
  description = "The group's wiki access level (Premium/Ultimate only). Valid values: disabled, private, enabled."
  type        = string
  default     = null

  validation {
    condition     = var.wiki_access_level == null || contains(["disabled", "private", "enabled"], var.wiki_access_level)
    error_message = "Wiki access level must be one of: disabled, private, enabled."
  }
}

# SHARED RUNNERS CONFIGURATION
# ============================

variable "shared_runners_setting" {
  description = "Enable or disable shared runners for subgroups and projects. Valid values: enabled, disabled_and_overridable, disabled_and_unoverridable, disabled_with_override."
  type        = string
  default     = null

  validation {
    condition = var.shared_runners_setting == null || contains([
      "enabled",
      "disabled_and_overridable",
      "disabled_and_unoverridable",
      "disabled_with_override"
    ], var.shared_runners_setting)
    error_message = "Shared runners setting must be one of: enabled, disabled_and_overridable, disabled_and_unoverridable, disabled_with_override."
  }
}

variable "shared_runners_minutes_limit" {
  description = "Maximum number of monthly CI/CD minutes for this group. Can be null (inherit system default), 0 (unlimited), or > 0. Administrator only."
  type        = number
  default     = null

  validation {
    condition     = var.shared_runners_minutes_limit == null || var.shared_runners_minutes_limit >= 0
    error_message = "Shared runners minutes limit must be null or >= 0."
  }
}

variable "extra_shared_runners_minutes_limit" {
  description = "Additional CI/CD minutes for this group. Administrator only."
  type        = number
  default     = null

  validation {
    condition     = var.extra_shared_runners_minutes_limit == null || var.extra_shared_runners_minutes_limit >= 0
    error_message = "Extra shared runners minutes limit must be null or >= 0."
  }
}

# TWO-FACTOR AUTHENTICATION
# =========================

variable "require_two_factor_authentication" {
  description = "Require all users in this group to setup Two-factor authentication."
  type        = bool
  default     = false
}

variable "two_factor_grace_period" {
  description = "Time before Two-factor authentication is enforced (in hours)."
  type        = number
  default     = 48

  validation {
    condition     = var.two_factor_grace_period >= 0
    error_message = "Two factor grace period must be >= 0 hours."
  }
}

# SECURITY SETTINGS
# =================

variable "ip_restriction_ranges" {
  description = "A list of IP addresses or subnet masks to restrict group access. Only allowed on top-level groups."
  type        = list(string)
  default     = []
}

# AVATAR CONFIGURATION
# ===================

variable "avatar" {
  description = "A local path to the avatar image to upload. Note: not available for imported resources."
  type        = string
  default     = null
}

variable "avatar_hash" {
  description = "The hash of the avatar image. Use filesha256('path/to/avatar.png') to trigger updates when avatar changes."
  type        = string
  default     = null
}

# DELETION BEHAVIOR
# ================

variable "permanently_remove_on_delete" {
  description = "Whether the group should be permanently removed during a delete operation. This only works with subgroups."
  type        = bool
  default     = false
}

# DEFAULT BRANCH PROTECTION DEFAULTS
# ==================================

variable "default_branch_protection_defaults" {
  description = "Default branch protection settings for all projects in the group."
  type = object({
    allowed_to_push            = optional(list(string), ["maintainer"])
    allow_force_push           = optional(bool, false)
    allowed_to_merge           = optional(list(string), ["maintainer"])
    developer_can_initial_push = optional(bool, false)
  })
  default = null

  validation {
    condition = var.default_branch_protection_defaults == null || alltrue([
      for level in concat(
        var.default_branch_protection_defaults.allowed_to_push,
        var.default_branch_protection_defaults.allowed_to_merge
      ) : contains(["developer", "maintainer", "no one"], level)
    ])
    error_message = "Access levels must be one of: developer, maintainer, no one."
  }
}

# PUSH RULES CONFIGURATION
# ========================

variable "push_rules" {
  description = "Push rules configuration for the group."
  type = object({
    author_email_regex            = optional(string)
    branch_name_regex             = optional(string)
    commit_committer_check        = optional(bool, false)
    commit_committer_name_check   = optional(bool, false)
    commit_message_negative_regex = optional(string)
    commit_message_regex          = optional(string)
    deny_delete_tag               = optional(bool, false)
    file_name_regex               = optional(string)
    max_file_size                 = optional(number)
    member_check                  = optional(bool, false)
    prevent_secrets               = optional(bool, false)
    reject_non_dco_commits        = optional(bool, false)
    reject_unsigned_commits       = optional(bool, false)
  })
  default = null

  validation {
    condition = var.push_rules == null || (
      var.push_rules.max_file_size == null || var.push_rules.max_file_size > 0
    )
    error_message = "Max file size must be greater than 0 MB if specified."
  }
}

# ==============================================================================
# VARIABLE GROUPS SUMMARY
# ==============================================================================
#
# REQUIRED VARIABLES:
# - name: Group name
# - path: Group URL path
#
# SECURITY VARIABLES:
# - visibility_level, ip_restriction_ranges
# - require_two_factor_authentication, two_factor_grace_period
# - push_rules (comprehensive commit and code validation)
# - default_branch_protection_defaults
#
# ACCESS CONTROL VARIABLES:
# - membership_lock, share_with_group_lock
# - request_access_enabled, prevent_forking_outside_group
# - project_creation_level, subgroup_creation_level
#
# OPERATIONAL VARIABLES:
# - shared_runners_setting, shared_runners_minutes_limit
# - lfs_enabled, auto_devops_enabled, wiki_access_level
# - emails_enabled, mentions_disabled
#
# ORGANIZATIONAL VARIABLES:
# - parent_id (for nested groups)
# - description, default_branch
# - avatar, avatar_hash
#
# ==============================================================================
