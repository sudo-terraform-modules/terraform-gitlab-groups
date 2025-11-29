# BASIC GROUP INFORMATION
# =======================

output "id" {
  description = "The ID of the GitLab group."
  value       = gitlab_group.this.id
}

output "name" {
  description = "The name of the GitLab group."
  value       = gitlab_group.this.name
}

output "path" {
  description = "The path of the GitLab group."
  value       = gitlab_group.this.path
}

output "full_name" {
  description = "The full name of the GitLab group."
  value       = gitlab_group.this.full_name
}

output "full_path" {
  description = "The full path of the GitLab group."
  value       = gitlab_group.this.full_path
}

output "description" {
  description = "The description of the GitLab group."
  value       = gitlab_group.this.description
}

# WEB ACCESS INFORMATION
# ======================

output "web_url" {
  description = "The web URL of the GitLab group."
  value       = gitlab_group.this.web_url
}

output "avatar_url" {
  description = "The URL of the group's avatar image."
  value       = gitlab_group.this.avatar_url
}

# RUNNERS AND CI/CD INFORMATION
# ============================

output "runners_token" {
  description = "The group level registration token to use during runner setup."
  value       = gitlab_group.this.runners_token
  sensitive   = true
}

# CONFIGURATION INFORMATION
# =========================

output "visibility_level" {
  description = "The visibility level of the group (private, internal, or public)."
  value       = gitlab_group.this.visibility_level
}

output "parent_id" {
  description = "The ID of the parent group (null for top-level groups)."
  value       = gitlab_group.this.parent_id
}

output "default_branch" {
  description = "The default branch name for new projects in this group."
  value       = gitlab_group.this.default_branch
}

# ACCESS AND PERMISSION INFORMATION
# =================================

output "request_access_enabled" {
  description = "Whether users can request member access to the group."
  value       = gitlab_group.this.request_access_enabled
}

output "membership_lock" {
  description = "Whether users cannot be added to projects in this group."
  value       = gitlab_group.this.membership_lock
}

output "share_with_group_lock" {
  description = "Whether sharing projects with other groups is prevented."
  value       = gitlab_group.this.share_with_group_lock
}

output "prevent_forking_outside_group" {
  description = "Whether forking projects to external namespaces is prevented."
  value       = gitlab_group.this.prevent_forking_outside_group
}

output "project_creation_level" {
  description = "The level of users who can create projects in the group."
  value       = gitlab_group.this.project_creation_level
}

output "subgroup_creation_level" {
  description = "The level of users who can create subgroups."
  value       = gitlab_group.this.subgroup_creation_level
}

# FEATURES AND INTEGRATIONS
# =========================

output "lfs_enabled" {
  description = "Whether Large File Storage (LFS) is enabled for projects in this group."
  value       = gitlab_group.this.lfs_enabled
}

output "auto_devops_enabled" {
  description = "Whether Auto DevOps is enabled for all projects in this group."
  value       = gitlab_group.this.auto_devops_enabled
}

output "wiki_access_level" {
  description = "The wiki access level for the group."
  value       = gitlab_group.this.wiki_access_level
}

# SHARED RUNNERS CONFIGURATION
# ============================

output "shared_runners_setting" {
  description = "The shared runners setting for the group's subgroups and projects."
  value       = gitlab_group.this.shared_runners_setting
}

output "shared_runners_minutes_limit" {
  description = "The maximum number of monthly CI/CD minutes for this group."
  value       = gitlab_group.this.shared_runners_minutes_limit
}

output "extra_shared_runners_minutes_limit" {
  description = "Additional CI/CD minutes for this group."
  value       = gitlab_group.this.extra_shared_runners_minutes_limit
}

# EMAIL AND NOTIFICATION SETTINGS
# ===============================

output "emails_enabled" {
  description = "Whether email notifications are enabled for the group."
  value       = gitlab_group.this.emails_enabled
}

output "mentions_disabled" {
  description = "Whether mentions are disabled for the group."
  value       = gitlab_group.this.mentions_disabled
}

output "allowed_email_domains_list" {
  description = "List of email domains allowed for group access."
  value       = gitlab_group.this.allowed_email_domains_list
}

# TWO-FACTOR AUTHENTICATION
# =========================

output "require_two_factor_authentication" {
  description = "Whether two-factor authentication is required for all users in this group."
  value       = gitlab_group.this.require_two_factor_authentication
}

output "two_factor_grace_period" {
  description = "Time before two-factor authentication is enforced (in hours)."
  value       = gitlab_group.this.two_factor_grace_period
}

# SECURITY SETTINGS
# =================

output "ip_restriction_ranges" {
  description = "List of IP addresses or subnet masks restricting group access."
  value       = gitlab_group.this.ip_restriction_ranges
}

# STRUCTURED OUTPUTS FOR COMPLEX CONFIGURATIONS
# =============================================

output "group_info" {
  description = "Comprehensive group information object containing all basic details."
  value = {
    id               = gitlab_group.this.id
    name             = gitlab_group.this.name
    path             = gitlab_group.this.path
    full_name        = gitlab_group.this.full_name
    full_path        = gitlab_group.this.full_path
    description      = gitlab_group.this.description
    web_url          = gitlab_group.this.web_url
    avatar_url       = gitlab_group.this.avatar_url
    parent_id        = gitlab_group.this.parent_id
    visibility_level = gitlab_group.this.visibility_level
  }
}

output "access_settings" {
  description = "Access control and permission settings for the group."
  value = {
    visibility_level              = gitlab_group.this.visibility_level
    request_access_enabled        = gitlab_group.this.request_access_enabled
    membership_lock               = gitlab_group.this.membership_lock
    share_with_group_lock         = gitlab_group.this.share_with_group_lock
    prevent_forking_outside_group = gitlab_group.this.prevent_forking_outside_group
    project_creation_level        = gitlab_group.this.project_creation_level
    subgroup_creation_level       = gitlab_group.this.subgroup_creation_level
  }
}

output "feature_settings" {
  description = "Feature and integration settings for the group."
  value = {
    lfs_enabled                = gitlab_group.this.lfs_enabled
    auto_devops_enabled        = gitlab_group.this.auto_devops_enabled
    wiki_access_level          = gitlab_group.this.wiki_access_level
    emails_enabled             = gitlab_group.this.emails_enabled
    mentions_disabled          = gitlab_group.this.mentions_disabled
    allowed_email_domains_list = gitlab_group.this.allowed_email_domains_list
  }
}

output "security_settings" {
  description = "Security configuration for the group."
  value = {
    require_two_factor_authentication = gitlab_group.this.require_two_factor_authentication
    two_factor_grace_period           = gitlab_group.this.two_factor_grace_period
    ip_restriction_ranges             = gitlab_group.this.ip_restriction_ranges
  }
}

output "cicd_settings" {
  description = "CI/CD and shared runners configuration for the group."
  value = {
    shared_runners_setting             = gitlab_group.this.shared_runners_setting
    shared_runners_minutes_limit       = gitlab_group.this.shared_runners_minutes_limit
    extra_shared_runners_minutes_limit = gitlab_group.this.extra_shared_runners_minutes_limit
  }
}

# CONVENIENCE OUTPUTS FOR COMMON USE CASES
# ========================================

output "namespace_id" {
  description = "The group ID for use as namespace_id in other resources (alias for id)."
  value       = gitlab_group.this.id
}

output "group_path_with_namespace" {
  description = "The full path of the group, useful for constructing URLs and references."
  value       = gitlab_group.this.full_path
}

output "is_top_level_group" {
  description = "Boolean indicating if this is a top-level group (no parent)."
  value       = gitlab_group.this.parent_id == null
}

output "group_url_slug" {
  description = "The URL slug for the group (same as path, provided for clarity)."
  value       = gitlab_group.this.path
}
