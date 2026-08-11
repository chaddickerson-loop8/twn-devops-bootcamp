# Section 08: CI/CD with GitHub Actions

Rebuild of TechWorld with Nana's "Build Automation & CI/CD with Jenkins" module using GitHub Actions instead of Jenkins, and AWS ECR instead of DockerHub/Nexus for image storage. See the repo-level [CLAUDE.md](../../CLAUDE.md) for the full role, security, cost, git workflow, and registry rules this section follows.

This README will be updated as work on the section progresses. See [progress.md](./progress.md) for the task-by-task checklist.

## Progress Log

### 2026-08-10
- Configured AWS CLI credentials locally using an existing IAM user with AdministratorAccess (via group membership).
- Verified credentials work with `aws sts get-caller-identity`.
- Terraform backend bootstrap code (S3 bucket + DynamoDB table, in `terraform-backend/`) was written and reviewed, but not yet applied.
- Next step: run `terraform init` / `plan` / `apply` on the backend bootstrap.
