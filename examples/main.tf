# ==============================================================================
# GITLAB GROUPS USAGE EXAMPLES
# ==============================================================================
# This file demonstrates how to use the GitLab Groups module to create
# different types of groups with various configurations.
# ==============================================================================

terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 18.0"
    }
  }
}

# Configure the GitLab Provider
provider "gitlab" {
  token    = var.gitlab_token
  base_url = var.gitlab_base_url # Optional: for self-hosted GitLab
}

# ==============================================================================
# BASIC GROUPS
# ==============================================================================

# ==============================================================================
# NESTED GROUPS (SUBGROUPS)
# ==============================================================================

# Main engineering parent group
module "engineering_group" {
  source  = "sudo-terraform-modules/groups/gitlab"
  version = "0.2.0"

  name        = "Engineering"
  path        = "engineering"
  description = "Main engineering organization"

  visibility_level        = "private"
  project_creation_level  = "developer"
  subgroup_creation_level = "maintainer"

  # CI/CD settings for engineering
  shared_runners_setting       = "enabled"
  shared_runners_minutes_limit = 50000
  auto_devops_enabled          = true
  lfs_enabled                  = true
}

# DevOps subgroup
module "devops_team" {
  source  = "sudo-terraform-modules/groups/gitlab"
  version = "0.2.0"

  name        = "DevOps Team"
  path        = "devops"
  description = "DevOps and infrastructure team"
  parent_id   = module.engineering_group.id

  # DevOps needs more permissions
  project_creation_level  = "developer"
  subgroup_creation_level = "maintainer"

  # Enhanced CI/CD access
  shared_runners_setting             = "enabled"
  extra_shared_runners_minutes_limit = 10000
}

# ==============================================================================
# DEVOPS SUBGROUPS
# ==============================================================================

# Migrations team subgroup
module "migrations_team" {
  source  = "sudo-terraform-modules/groups/gitlab"
  version = "0.2.0"

  name        = "Migrations Team"
  path        = "migrations"
  description = "Database and application migration team"
  parent_id   = module.devops_team.id

  visibility_level       = "private"
  project_creation_level = "developer"

  # Migration specific settings
  lfs_enabled                  = true
  shared_runners_setting       = "enabled"
  shared_runners_minutes_limit = 15000
}

# Infrastructure team subgroup
module "infrastructure_team" {
  source  = "sudo-terraform-modules/groups/gitlab"
  version = "0.2.0"

  name        = "Infrastructure Team"
  path        = "infrastructure"
  description = "Cloud and on-premises infrastructure management"
  parent_id   = module.devops_team.id

  visibility_level       = "private"
  project_creation_level = "developer"

  # Infrastructure specific settings
  lfs_enabled                  = true
  shared_runners_setting       = "enabled"
  shared_runners_minutes_limit = 20000
  auto_devops_enabled          = true
}

# Automation team subgroup
module "automation_team" {
  source  = "sudo-terraform-modules/groups/gitlab"
  version = "0.2.0"

  name        = "Automation Team"
  path        = "automation"
  description = "DevOps automation and CI/CD pipelines"
  parent_id   = module.devops_team.id

  visibility_level       = "private"
  project_creation_level = "developer"

  # Automation specific settings
  auto_devops_enabled          = true
  shared_runners_setting       = "enabled"
  shared_runners_minutes_limit = 25000
  lfs_enabled                  = true
}

# Compute team subgroup
module "compute_team" {
  source  = "sudo-terraform-modules/groups/gitlab"
  version = "0.2.0"

  name        = "Compute Team"
  path        = "compute"
  description = "Server and container compute infrastructure"
  parent_id   = module.devops_team.id

  visibility_level       = "private"
  project_creation_level = "developer"

  # Compute specific settings
  lfs_enabled                  = true
  shared_runners_setting       = "enabled"
  shared_runners_minutes_limit = 18000
}

# SAP BASIS team subgroup
module "sap_basis_team" {
  source  = "sudo-terraform-modules/groups/gitlab"
  version = "0.2.0"

  name        = "SAP BASIS Team"
  path        = "sap-basis"
  description = "SAP system administration and BASIS management"
  parent_id   = module.devops_team.id

  visibility_level       = "private"
  project_creation_level = "maintainer"

  # SAP BASIS specific settings
  lfs_enabled                  = true
  shared_runners_setting       = "disabled_and_overridable" # SAP may need custom runners
  shared_runners_minutes_limit = 10000
}

# ==============================================================================
# SAP BASIS SUBGROUPS
# ==============================================================================

# SAP S/4HANA team subgroup
module "sap_s4hana_team" {
  source  = "sudo-terraform-modules/groups/gitlab"
  version = "0.2.0"

  name        = "SAP S4 HANA"
  path        = "sap-s4hana"
  description = "SAP S/4HANA system administration and development"
  parent_id   = module.sap_basis_team.id

  visibility_level       = "private"
  project_creation_level = "maintainer"

  # S/4HANA specific settings
  lfs_enabled                  = true
  shared_runners_setting       = "disabled_and_overridable"
  shared_runners_minutes_limit = 8000

  # Strict security for production SAP systems
  require_two_factor_authentication = true
  two_factor_grace_period           = 72
}

# SAP Business One team subgroup
module "sap_b1_team" {
  source  = "sudo-terraform-modules/groups/gitlab"
  version = "0.2.0"

  name        = "SAP B1"
  path        = "sap-b1"
  description = "SAP Business One system administration and customization"
  parent_id   = module.sap_basis_team.id

  visibility_level       = "private"
  project_creation_level = "maintainer"

  # Business One specific settings
  lfs_enabled                  = true
  shared_runners_setting       = "disabled_and_overridable"
  shared_runners_minutes_limit = 5000

  # Security settings
  require_two_factor_authentication = true
  two_factor_grace_period           = 72
}

# SAP NetWeaver team subgroup
module "sap_netweaver_team" {
  source  = "sudo-terraform-modules/groups/gitlab"
  version = "0.2.0"

  name        = "SAP NetWeaver"
  path        = "sap-netweaver"
  description = "SAP NetWeaver platform administration and ABAP development"
  parent_id   = module.sap_basis_team.id

  visibility_level       = "private"
  project_creation_level = "maintainer"

  # NetWeaver specific settings
  lfs_enabled                  = true
  shared_runners_setting       = "disabled_and_overridable"
  shared_runners_minutes_limit = 6000

  # Security settings for ABAP development
  require_two_factor_authentication = true
  two_factor_grace_period           = 72

  # Push rules for ABAP code quality
  # push_rules = {
  #   prevent_secrets        = true
  #   commit_committer_check = true
  #   member_check           = true
  #   max_file_size          = 50 # ABAP objects can be large
  # }
}

# ==============================================================================
# SECURE GROUPS WITH ADVANCED FEATURES
# ==============================================================================

# Security team with maximum security
module "security_group" {
  source  = "sudo-terraform-modules/groups/gitlab"
  version = "0.2.0"

  name        = "Security Team"
  path        = "security"
  description = "Information security and compliance team"

  # Maximum security settings
  visibility_level                  = "private"
  require_two_factor_authentication = true
  two_factor_grace_period           = 0 # Immediate enforcement
  membership_lock                   = true
  share_with_group_lock             = true
  prevent_forking_outside_group     = true

  # Strict access controls
  project_creation_level  = "owner"
  subgroup_creation_level = "owner"

  # Email domain restrictions
  allowed_email_domains_list = ["company.com", "security-contractor.com"]

  # Push rules require GitLab Enterprise
  # push_rules = {
  #   prevent_secrets              = true
  #   commit_committer_check      = true
  #   commit_committer_name_check = true
  #   member_check                = true
  #   reject_unsigned_commits     = true
  #   author_email_regex          = "@(company|security-contractor)\\.com$"
  #   commit_message_regex        = "^(feat|fix|docs|style|refactor|test|chore|security):"
  #   max_file_size              = 50 # 50 MB limit
  #   deny_delete_tag            = true
  #   file_name_regex            = "\\.(key|pem|p12|pfx)$" # Block private key files
  # }

  # Strict branch protection
  default_branch_protection_defaults = {
    allowed_to_push            = ["no one"]
    allow_force_push           = false
    allowed_to_merge           = ["maintainer"]
    developer_can_initial_push = false
  }

  # No shared runners for security
  shared_runners_setting = "disabled_and_unoverridable"
}

# Production operations group
module "production_group" {
  source  = "sudo-terraform-modules/groups/gitlab"
  version = "0.2.0"

  name        = "Production Operations"
  path        = "production"
  description = "Production systems and operations"

  # Production security settings
  visibility_level                  = "private"
  require_two_factor_authentication = true
  two_factor_grace_period           = 24
  prevent_forking_outside_group     = true

  # Limited access
  project_creation_level = "maintainer"
  membership_lock        = true

  # Push rules require GitLab Enterprise
  # push_rules = {
  #   prevent_secrets         = true
  #   commit_committer_check = true
  #   member_check          = true
  #   reject_unsigned_commits = false # Some flexibility for ops
  #   deny_delete_tag       = true
  #   max_file_size        = 200 # Larger files for deployment artifacts
  # }

  # Controlled CI/CD
  shared_runners_setting       = "disabled_and_overridable"
  shared_runners_minutes_limit = 20000
}

# ==============================================================================
# SPECIALIZED GROUPS
# ==============================================================================

# Open source projects group
module "opensource_group" {
  source  = "sudo-terraform-modules/groups/gitlab"
  version = "0.2.0"

  name        = "Open Source Projects"
  path        = "opensource"
  description = "Public open source projects and contributions"

  # Public visibility for open source
  visibility_level       = "public"
  request_access_enabled = true

  # More open access for collaboration
  project_creation_level = "developer"

  # Open source friendly settings
  prevent_forking_outside_group = false # Allow external forks
  lfs_enabled                   = true

  # Push rules require GitLab Enterprise
  # push_rules = {
  #   prevent_secrets = true
  #   max_file_size  = 100
  # }

  # Enable shared runners for CI
  shared_runners_setting = "enabled"
}

# Documentation group
module "documentation_group" {
  source  = "sudo-terraform-modules/groups/gitlab"
  version = "0.2.0"

  name        = "Documentation"
  path        = "docs"
  description = "Technical documentation and knowledge base"

  visibility_level       = "private"
  project_creation_level = "developer"

  # Documentation specific settings
  wiki_access_level = "enabled"
  lfs_enabled       = false # Docs don't typically need LFS

  # Push rules require GitLab Enterprise
  # push_rules = {
  #   max_file_size = 20 # Keep docs lightweight
  # }
}

# ==============================================================================
# OUTPUTS FOR REFERENCE
# ==============================================================================

output "groups_created" {
  description = "Summary of all created groups"
  value = {
    qa = {ering = {
      id        = module.engineering_group.id
      web_url   = module.engineering_group.web_url
      full_path = module.engineering_group.full_path
      subgroups = {
        devops   = module.devops_team.full_path
      }
    }
    devops = {
      id        = module.devops_team.id
      web_url   = module.devops_team.web_url
      full_path = module.devops_team.full_path
      subgroups = {
        migrations     = module.migrations_team.full_path
        infrastructure = module.infrastructure_team.full_path
        automation     = module.automation_team.full_path
        compute        = module.compute_team.full_path
        sap_basis      = module.sap_basis_team.full_path
      }
    }
    sap_basis = {
      id        = module.sap_basis_team.id
      web_url   = module.sap_basis_team.web_url
      full_path = module.sap_basis_team.full_path
      subgroups = {
        s4_hana      = module.sap_s4hana_team.full_path
        business_one = module.sap_b1_team.full_path
        netweaver    = module.sap_netweaver_team.full_path
      }
    }
    security = {
      id        = module.security_group.id
      web_url   = module.security_group.web_url
      full_path = module.security_group.full_path
    }
    production = {
      id        = module.production_group.id
      web_url   = module.production_group.web_url
      full_path = module.production_group.full_path
    }
    opensource = {
      id        = module.opensource_group.id
      web_url   = module.opensource_group.web_url
      full_path = module.opensource_group.full_path
    }
    documentation = {
      id        = module.documentation_group.id
      web_url   = module.documentation_group.web_url
      full_path = module.documentation_group.full_path
    }
  }
}
}