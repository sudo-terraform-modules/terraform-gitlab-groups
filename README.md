# GitLab Groups Terraform Module

A comprehensive Terraform module for creating and managing GitLab groups with full support for security settings, access controls, and organizational features.

## Features

- **Complete GitLab Group Management** - Full support for all `gitlab_group` resource features
- **Advanced Security Settings** - Two-factor authentication, IP restrictions, and push rules
- **Access Control** - Granular permissions for project/subgroup creation and membership
- **CI/CD Integration** - Shared runners configuration and minutes management
- **Organizational Structure** - Support for nested groups and inheritance
- **Communication Controls** - Email domain restrictions and notification settings
- **Branch Protection** - Default branch protection rules for all projects
- **Comprehensive Outputs** - All group information available for use in other resources

## Usage

### Basic Group

```hcl
module "basic_group" {
  source = "./modules/gitlab-groups"

  name        = "development-team"
  path        = "dev-team"
  description = "Development team group"
}
```

### Advanced Group with Security Features

```hcl
module "secure_group" {
  source = "./modules/gitlab-groups"

  # Basic Configuration
  name        = "security-team"
  path        = "sec-team"
  description = "Security team with enhanced controls"
  
  # Visibility and Access Control
  visibility_level               = "private"
  prevent_forking_outside_group = true
  membership_lock               = true
  
  # Security Settings
  require_two_factor_authentication = true
  two_factor_grace_period          = 24
  ip_restriction_ranges            = ["192.168.1.0/24", "10.0.0.0/8"]
  
  # Email Restrictions
  allowed_email_domains_list = ["company.com", "contractor.company.com"]
  
  # Push Rules
  push_rules = {
    prevent_secrets         = true
    commit_committer_check  = true
    member_check           = true
    author_email_regex     = "@(company|contractor)\\.com$"
    reject_unsigned_commits = true
  }
  
  # Default Branch Protection
  default_branch_protection_defaults = {
    allowed_to_push            = ["maintainer"]
    allow_force_push           = false
    allowed_to_merge           = ["maintainer"]
    developer_can_initial_push = false
  }
}
```

### Nested Subgroup

```hcl
# Parent group
module "engineering_group" {
  source = "./modules/gitlab-groups"

  name        = "Engineering"
  path        = "engineering"
  description = "Main engineering group"
  
  subgroup_creation_level = "maintainer"
  project_creation_level  = "developer"
}

# Child subgroup
module "backend_team" {
  source = "./modules/gitlab-groups"

  name        = "Backend Team"
  path        = "backend"
  description = "Backend development team"
  parent_id   = module.engineering_group.id
}
```

### Group with Shared Runners and CI/CD Limits

```hcl
module "cicd_group" {
  source = "./modules/gitlab-groups"

  name        = "CI/CD Projects"
  path        = "cicd-projects"
  description = "Group for CI/CD intensive projects"
  
  # Shared Runners Configuration
  shared_runners_setting              = "enabled"
  shared_runners_minutes_limit        = 10000
  extra_shared_runners_minutes_limit  = 5000
  
  # Enable Auto DevOps
  auto_devops_enabled = true
  
  # Large File Storage
  lfs_enabled = true
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| gitlab | ~> 18.0 |

## Providers

| Name | Version |
|------|---------|
| gitlab | ~> 18.0 |

## Inputs

### Required

| Name | Description | Type |
|------|-------------|------|
| name | The name of the GitLab group | `string` |
| path | The path of the GitLab group (URL slug) | `string` |

### Optional

| Name | Description | Type | Default |
|------|-------------|------|---------|
| description | A description of the GitLab group | `string` | `null` |
| visibility_level | The visibility level of the group (private, internal, public) | `string` | `"private"` |
| parent_id | The ID of the parent group (creates nested group) | `number` | `null` |
| project_creation_level | Who can create projects (noone, owner, maintainer, developer, administrator) | `string` | `"maintainer"` |
| subgroup_creation_level | Who can create subgroups (owner, maintainer) | `string` | `"owner"` |
| require_two_factor_authentication | Require 2FA for all group members | `bool` | `false` |
| two_factor_grace_period | 2FA enforcement grace period (hours) | `number` | `48` |
| lfs_enabled | Enable Large File Storage for projects | `bool` | `true` |
| shared_runners_setting | Shared runners configuration | `string` | `null` |
| ip_restriction_ranges | IP addresses/subnets for access restriction | `list(string)` | `[]` |
| allowed_email_domains_list | Allowed email domains for group access | `list(string)` | `[]` |

<details>
<summary>View all input variables</summary>

For a complete list of all input variables, see the [variables.tf](./variables.tf) file. The module supports all GitLab group features including:

- **Access Control**: membership_lock, share_with_group_lock, prevent_forking_outside_group
- **Features**: auto_devops_enabled, wiki_access_level, emails_enabled, mentions_disabled
- **CI/CD**: shared_runners_minutes_limit, extra_shared_runners_minutes_limit
- **Avatar**: avatar, avatar_hash
- **Advanced Security**: push_rules object with comprehensive commit validation
- **Branch Protection**: default_branch_protection_defaults object

</details>

## Outputs

### Basic Outputs

| Name | Description |
|------|-------------|
| id | The ID of the GitLab group |
| name | The name of the GitLab group |
| path | The path of the GitLab group |
| full_name | The full name of the GitLab group |
| full_path | The full path of the GitLab group |
| web_url | The web URL of the GitLab group |
| runners_token | Group registration token for runners (sensitive) |

### Structured Outputs

| Name | Description |
|------|-------------|
| group_info | Comprehensive group information object |
| access_settings | Access control and permission settings |
| security_settings | Security configuration |
| cicd_settings | CI/CD and shared runners configuration |
| feature_settings | Feature and integration settings |

### Convenience Outputs

| Name | Description |
|------|-------------|
| namespace_id | Group ID for use as namespace_id (alias for id) |
| is_top_level_group | Boolean indicating if this is a top-level group |

<details>
<summary>View all outputs</summary>

For a complete list of all outputs, see the [outputs.tf](./outputs.tf) file.

</details>

## Examples

### Creating a Project in the Group

```hcl
# Create the group
module "my_group" {
  source = "./modules/gitlab-groups"

  name        = "my-team"
  path        = "my-team"
  description = "My development team"
}

# Create a project in the group
resource "gitlab_project" "my_project" {
  name         = "awesome-app"
  description  = "Our awesome application"
  namespace_id = module.my_group.namespace_id
  
  visibility_level = module.my_group.visibility_level
}
```

### Enterprise Group with Full Security

```hcl
module "enterprise_group" {
  source = "./modules/gitlab-groups"

  name        = "Enterprise Applications"
  path        = "enterprise-apps"
  description = "Enterprise-grade applications with full security"
  
  # Maximum security settings
  visibility_level                  = "private"
  require_two_factor_authentication = true
  two_factor_grace_period          = 0  # Immediate enforcement
  membership_lock                  = true
  share_with_group_lock           = true
  prevent_forking_outside_group   = true
  
  # Strict access controls
  project_creation_level  = "owner"
  subgroup_creation_level = "owner"
  
  # Corporate email requirements
  allowed_email_domains_list = ["company.com"]
  
  # Comprehensive push rules
  push_rules = {
    prevent_secrets              = true
    commit_committer_check      = true
    commit_committer_name_check = true
    member_check                = true
    reject_unsigned_commits     = true
    author_email_regex          = "@company\\.com$"
    commit_message_regex        = "^(feat|fix|docs|style|refactor|test|chore):"
    max_file_size              = 100  # 100 MB limit
    deny_delete_tag            = true
  }
  
  # Strict branch protection
  default_branch_protection_defaults = {
    allowed_to_push            = ["no one"]
    allow_force_push           = false
    allowed_to_merge           = ["maintainer"]
    developer_can_initial_push = false
  }
  
  # Restricted runners
  shared_runners_setting = "disabled_and_unoverridable"
}
```

## Module Structure

```
├── .github/
│   └── workflows/          # CI/CD pipeline configurations
├── .gitignore              # Git ignore patterns
├── LICENSE                 # Module license
├── README.md               # Module documentation
├── examples/               # Usage examples and configurations
│   ├── main.tf             # Complete example with all features
│   ├── variables.tf        # Example variable definitions
│   └── terraform.tfvars    # Example variable values
├── main.tf                 # GitLab group resource configuration
├── outputs.tf              # Output value definitions
├── variables.tf            # Input variable definitions with validation
└── versions.tf             # Terraform and provider version constraints
```

## Validation and Best Practices

The module includes comprehensive input validation:

- **Path Validation**: Ensures group path contains only valid characters
- **Access Level Validation**: Validates all access levels against GitLab's allowed values
- **Email Regex Validation**: Ensures push rule email patterns are valid
- **Numeric Constraints**: Validates time periods, file sizes, and limits
- **Conditional Validation**: Context-aware validation based on other variables

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes following the existing code style
4. Add or update tests as needed
5. Update documentation
6. Commit your changes (`git commit -m 'feat: add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Development Guidelines

- Follow Terraform best practices and style guidelines
- Add validation for new variables where appropriate
- Update documentation for any new features or changes
- Test with multiple GitLab provider versions
- Ensure backward compatibility when possible

## Security Considerations

When using this module in production:

1. **Review Default Values**: Ensure default settings align with your security requirements
2. **Enable 2FA**: Consider enabling two-factor authentication for sensitive groups
3. **IP Restrictions**: Use IP restrictions for highly sensitive groups
4. **Push Rules**: Implement appropriate push rules for code quality and security
5. **Access Levels**: Use principle of least privilege for creation permissions
6. **Email Domains**: Restrict access to corporate email domains

## License

This module is licensed under the MIT License. See [LICENSE](./LICENSE) file for details.

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for version history and changes.

---

**Note**: This module requires GitLab 13.0+ for full feature compatibility. Some advanced features may require GitLab Premium or Ultimate subscriptions.
