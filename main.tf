# GITLAB GROUP RESOURCE
# =====================
resource "gitlab_group" "this" {
  # REQUIRED ATTRIBUTES
  # ==================
  name = var.name
  path = var.path

  # OPTIONAL BASIC CONFIGURATION
  # ============================
  description    = var.description
  default_branch = var.default_branch
  parent_id      = var.parent_id

  # VISIBILITY AND ACCESS CONTROL
  # =============================
  visibility_level              = var.visibility_level
  request_access_enabled        = var.request_access_enabled
  membership_lock               = var.membership_lock
  share_with_group_lock         = var.share_with_group_lock
  prevent_forking_outside_group = var.prevent_forking_outside_group

  # PROJECT AND SUBGROUP CREATION PERMISSIONS
  # =========================================
  project_creation_level  = var.project_creation_level
  subgroup_creation_level = var.subgroup_creation_level

  # EMAIL AND NOTIFICATION SETTINGS
  # ===============================
  emails_enabled             = var.emails_enabled
  mentions_disabled          = var.mentions_disabled
  allowed_email_domains_list = var.allowed_email_domains_list

  # LARGE FILE STORAGE (LFS) CONFIGURATION
  # ======================================
  lfs_enabled = var.lfs_enabled

  # AUTO DEVOPS CONFIGURATION
  # =========================
  auto_devops_enabled = var.auto_devops_enabled

  # WIKI ACCESS CONFIGURATION
  # =========================
  wiki_access_level = var.wiki_access_level

  # SHARED RUNNERS CONFIGURATION
  # ============================
  shared_runners_setting             = var.shared_runners_setting
  shared_runners_minutes_limit       = var.shared_runners_minutes_limit
  extra_shared_runners_minutes_limit = var.extra_shared_runners_minutes_limit

  # TWO-FACTOR AUTHENTICATION SETTINGS
  # ==================================
  require_two_factor_authentication = var.require_two_factor_authentication
  two_factor_grace_period           = var.two_factor_grace_period

  # IP RESTRICTION (Top-level groups only)
  # ======================================
  ip_restriction_ranges = var.ip_restriction_ranges

  # AVATAR CONFIGURATION
  # ===================
  avatar      = var.avatar
  avatar_hash = var.avatar_hash

  # PERMANENT REMOVAL ON DELETE (Subgroups only)
  # ============================================
  permanently_remove_on_delete = var.permanently_remove_on_delete

  # DEFAULT BRANCH PROTECTION DEFAULTS
  # ==================================
  dynamic "default_branch_protection_defaults" {
    for_each = var.default_branch_protection_defaults != null ? [var.default_branch_protection_defaults] : []

    content {
      allowed_to_push            = default_branch_protection_defaults.value.allowed_to_push
      allow_force_push           = default_branch_protection_defaults.value.allow_force_push
      allowed_to_merge           = default_branch_protection_defaults.value.allowed_to_merge
      developer_can_initial_push = default_branch_protection_defaults.value.developer_can_initial_push
    }
  }

  # PUSH RULES CONFIGURATION
  # ========================
  dynamic "push_rules" {
    for_each = var.push_rules != null ? [var.push_rules] : []

    content {
      author_email_regex            = push_rules.value.author_email_regex
      branch_name_regex             = push_rules.value.branch_name_regex
      commit_committer_check        = push_rules.value.commit_committer_check
      commit_committer_name_check   = push_rules.value.commit_committer_name_check
      commit_message_negative_regex = push_rules.value.commit_message_negative_regex
      commit_message_regex          = push_rules.value.commit_message_regex
      deny_delete_tag               = push_rules.value.deny_delete_tag
      file_name_regex               = push_rules.value.file_name_regex
      max_file_size                 = push_rules.value.max_file_size
      member_check                  = push_rules.value.member_check
      prevent_secrets               = push_rules.value.prevent_secrets
      reject_non_dco_commits        = push_rules.value.reject_non_dco_commits
      reject_unsigned_commits       = push_rules.value.reject_unsigned_commits
    }
  }
}
