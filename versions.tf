# ==============================================================================
# TERRAFORM VERSION CONSTRAINTS CONFIGURATION
# ==============================================================================
# This file defines the minimum required Terraform version and provider versions
# for this module. Proper version constraints are crucial for:
# 1. Ensuring compatibility across different environments
# 2. Preventing breaking changes from automatic updates
# 3. Maintaining reproducible infrastructure deployments
# 4. Avoiding dependency conflicts in complex module hierarchies

terraform {
  # TERRAFORM CORE VERSION CONSTRAINT
  # ================================
  # Specifies the minimum Terraform version required for this module
  # Best practice: Use ">= x.y.z" for modules to allow forward compatibility
  # Alternative approaches:
  #   - "= 1.3.0"           → Exact version (too restrictive for modules)
  #   - "~> 1.3.0"          → Allow patch updates only (1.3.x)
  #   - ">= 1.3.0, < 2.0.0" → Range with upper bound (good for major version boundaries)
  required_version = ">= 1.3.0"

  required_providers {
    # GITLAB PROVIDER CONFIGURATION  
    # =============================
    gitlab = {
      source = "gitlabhq/gitlab"
      # VERSION CONSTRAINT EXPLANATION:
      # "~> 18.6" means >= 18.6.0 AND < 19.0.0 (pessimistic constraint)
      # This allows:
      #   18.6.0, 18.6.1, 18.7.0, 18.99.999 (patch and minor updates)
      # This prevents:
      #   19.0.0, 20.0.0 (major updates that might introduce breaking changes)
      version = "~> 18.6"
    }
  }
}

# ==============================================================================
# VERSION CONSTRAINT BEST PRACTICES
# ==============================================================================
#
# 1. FOR TERRAFORM MODULES:
#    - Use ">= x.y.z" for Terraform core (allows forward compatibility)
#    - Use "~> x.y" for providers (balances updates with stability)
#    - Document any known incompatibilities in README
#
# 2. FOR ROOT CONFIGURATIONS:
#    - Be more specific with versions for production environments
#    - Consider using exact versions for critical infrastructure
#    - Use .terraform.lock.hcl for reproducible builds
#
# 3. CONSTRAINT OPERATORS SUMMARY:
#    Operator | Example    | Meaning
#    ---------|------------|--------------------------------------------------
#    =        | = 1.0.0    | Exactly version 1.0.0
#    !=       | != 1.0.0   | Any version except 1.0.0
#    >        | > 1.0.0    | Greater than 1.0.0
#    >=       | >= 1.0.0   | Greater than or equal to 1.0.0
#    <        | < 2.0.0    | Less than 2.0.0
#    <=       | <= 2.0.0   | Less than or equal to 2.0.0
#    ~>       | ~> 1.0.0   | >= 1.0.0 and < 1.1.0 (pessimistic constraint)
#    ~>       | ~> 1.0     | >= 1.0.0 and < 2.0.0
#
# 4. SECURITY CONSIDERATIONS:
#    - Regularly review and update provider versions for security patches
#    - Use Dependabot or similar tools for automated dependency updates
#    - Test version updates in non-production environments first
#    - Monitor provider changelogs for breaking changes
#
# 5. TROUBLESHOOTING VERSION CONFLICTS:
#    - Use 'terraform providers' to see resolved versions
#    - Check .terraform.lock.hcl for locked versions
#    - Use 'terraform init -upgrade' to update to latest allowed versions
#    - Consider 'terraform providers lock' for cross-platform compatibility
#
# ==============================================================================