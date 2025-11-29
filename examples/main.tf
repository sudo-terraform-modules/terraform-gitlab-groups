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

# Simple development group
module "development_group" {
  source = "../"

  name        = "Development Team"
  path        = "development"
  description = "Main development team for all projects"

  # Basic settings
  visibility_level        = "private"
  project_creation_level  = "developer"
  subgroup_creation_level = "maintainer"

  # Enable useful features
  lfs_enabled         = true
  auto_devops_enabled = true
}

# QA/Testing group
module "qa_group" {
  source = "../"

  name        = "Quality Assurance"
  path        = "qa"
  description = "Quality assurance and testing team"

  visibility_level       = "private"
  project_creation_level = "maintainer"

  # QA specific settings
  shared_runners_setting = "enabled"
  lfs_enabled            = true
}

# ==============================================================================
# NESTED GROUPS (SUBGROUPS)
# ==============================================================================

# Main engineering parent group
module "engineering_group" {
  source = "../"

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

# Backend engineering subgroup
module "backend_team" {
  source = "../"

  name        = "Backend Team"
  path        = "backend"
  description = "Backend development team"
  parent_id   = module.engineering_group.id

  # Inherit from parent but more restrictive
  visibility_level       = "private"
  project_creation_level = "developer"

  # Backend specific features
  lfs_enabled = true
}

# Frontend engineering subgroup
module "frontend_team" {
  source = "../"

  name        = "Frontend Team"
  path        = "frontend"
  description = "Frontend development team"
  parent_id   = module.engineering_group.id

  visibility_level       = "private"
  project_creation_level = "developer"

  # Frontend specific settings
  auto_devops_enabled = true
  lfs_enabled         = false # Frontend typically doesn't need LFS
}

# DevOps subgroup
module "devops_team" {
  source = "../"

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
# SECURE GROUPS WITH ADVANCED FEATURES
# ==============================================================================

# Security team with maximum security
module "security_group" {
  source = "../"

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
  source = "../"

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
  source = "../"

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
  source = "../"

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

# Research and development group
module "research_group" {
  source = "../"

  name        = "Research and Development"
  path        = "research"
  description = "Experimental projects and research initiatives"

  visibility_level       = "private"
  project_creation_level = "developer"

  # R&D friendly settings
  auto_devops_enabled = true
  lfs_enabled         = true # For datasets and models

  # Push rules require GitLab Enterprise
  # push_rules = {
  #   prevent_secrets = true
  #   max_file_size  = 500 # Large files for research data
  # }

  # Generous CI/CD limits for experimentation
  shared_runners_setting       = "enabled"
  shared_runners_minutes_limit = 30000
}

# ==============================================================================
# OUTPUTS FOR REFERENCE
# ==============================================================================

output "groups_created" {
  description = "Summary of all created groups"
  value = {
    development = {
      id        = module.development_group.id
      web_url   = module.development_group.web_url
      full_path = module.development_group.full_path
    }
    qa = {
      id        = module.qa_group.id
      web_url   = module.qa_group.web_url
      full_path = module.qa_group.full_path
    }
    engineering = {
      id        = module.engineering_group.id
      web_url   = module.engineering_group.web_url
      full_path = module.engineering_group.full_path
      subgroups = {
        backend  = module.backend_team.full_path
        frontend = module.frontend_team.full_path
        devops   = module.devops_team.full_path
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
    research = {
      id        = module.research_group.id
      web_url   = module.research_group.web_url
      full_path = module.research_group.full_path
    }
  }
}