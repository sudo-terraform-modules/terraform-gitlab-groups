# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-11-29

### Added

- Initial release of GitLab Groups Terraform module
- Complete GitLab group resource configuration with all available attributes
- Comprehensive input variable definitions with validation
- Advanced security features support:
  - Two-factor authentication enforcement
  - IP restriction ranges for access control
  - Push rules with commit validation
  - Default branch protection settings
- Access control and permission management:
  - Project and subgroup creation level controls
  - Membership and sharing restrictions
  - Forking prevention controls
- CI/CD integration features:
  - Shared runners configuration
  - Minutes limits management
  - Auto DevOps support
- Communication and notification controls:
  - Email domain restrictions
  - Notification settings
  - Wiki access level configuration
- Organizational structure support:
  - Nested groups (parent-child relationships)
  - Visibility level management
  - Avatar configuration
- Comprehensive output values:
  - Basic group information
  - Structured outputs for easy integration
  - Convenience outputs for common use cases
- Input validation for all variables:
  - Path validation with regex patterns
  - Access level validation
  - Numeric constraint validation
  - Email domain validation
- Complete documentation:
  - Usage examples (basic, advanced, enterprise)
  - Input/output reference tables
  - Security considerations
  - Contributing guidelines
- Example configurations:
  - Simple setup for basic usage
  - Complete setup with advanced features
  - Automated setup script
  - Variable examples with documentation
- Terraform version constraints:
  - Terraform >= 1.3.0
  - GitLab provider ~> 17.0

### Technical Details

- **Provider Support**: GitLab provider v17.0+ for full feature compatibility
- **Terraform Compatibility**: Requires Terraform 1.3.0 or higher
- **Module Structure**: Follows Terraform module best practices
- **Validation**: Comprehensive input validation to prevent configuration errors
- **Documentation**: Complete API reference and usage examples

[0.1.0]: https://github.com/SUDO-Terraform-Modules/gitlab-groups/releases/tag/v0.1.0
