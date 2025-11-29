# ==============================================================================
# TERRAFORM VARIABLES VALUES
# ==============================================================================
# This file contains example values for variables. 
# Copy this file to terraform.tfvars and update with your actual values.
# ==============================================================================

# GITLAB AUTHENTICATION
# =====================
# Get your token from: GitLab CE > User Settings > Access Tokens
# Required scopes: api, read_user, read_repository, write_repository
gitlab_token = "glpat-*********************************************"

# GitLab CE instance URL
gitlab_base_url = "https://gitlab.*****************.com/api/v4/"

# ORGANIZATION CONFIGURATION
# =========================
organization_name    = "Your Team or Company Name"
company_email_domain = "yourcompany.com"

# SECURITY SETTINGS
# ================
enable_security_features      = true
require_2fa_for_secure_groups = true
default_visibility            = "private"

# Optional: Restrict access to specific IP ranges
# allowed_ip_ranges = [
#   "192.168.1.0/24",    # Office network
#   "10.0.0.0/8",        # VPN range
#   "203.0.113.0/24"     # External contractor range
# ]

# CI/CD CONFIGURATION
# ==================
shared_runners_minutes_limit = 20000
enable_auto_devops           = true

# ==============================================================================
# IMPORTANT NOTES
# ==============================================================================
#
# 1. GITLAB TOKEN SETUP:
#    - Go to GitLab > User Settings > Access Tokens
#    - Create a token with scopes: api, read_user, read_repository, write_repository
#    - For group creation, you need Owner or Maintainer access
#
# 2. SECURITY CONSIDERATIONS:
#    - Never commit terraform.tfvars to version control
#    - Use environment variables for tokens in CI/CD: TF_VAR_gitlab_token
#    - Consider using GitLab CI variables for automation
#
# 3. SELF-HOSTED GITLAB:
#    - Update gitlab_base_url for your instance
#    - Ensure API v4 is enabled
#    - Check SSL certificate configuration
#
# 4. GROUP PERMISSIONS:
#    - You need sufficient permissions to create groups
#    - Top-level groups require Owner permissions on GitLab.com
#    - Consider creating groups through UI first, then importing
#
# ==============================================================================