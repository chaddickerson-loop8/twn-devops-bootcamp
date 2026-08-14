# Section 08: CI/CD with GitHub Actions (rebuilding Jenkins module)

Rebuild of TechWorld with Nana's "Build Automation & CI/CD with Jenkins" module, using GitHub Actions + AWS per [CLAUDE.md](../../CLAUDE.md).

## Intro to Build Automation

- [ ] Not Started — Review build automation concepts (tool-agnostic, no rebuild needed)

## Terraform Foundation

- [x] Done — Write Terraform backend bootstrap config (S3 bucket for state + DynamoDB table for locking) in `terraform-backend/` — *note: this is a one-time manual bootstrap (local state only, no `backend` block — see `terraform-backend/README.md`), not something GitHub Actions runs. Applied successfully and independently verified in the AWS Console: S3 bucket `chaddickerson-twn-devops-tfstate` and DynamoDB table `twn-devops-bootcamp-tfstate-lock` now exist in AWS (see `screenshots/s3-bucket-created-console-view.png` and `screenshots/dynamodb-table-created-console-view.png`).*
- [x] Done — Configure local AWS CLI credentials (aws configure) and verify via `aws sts get-caller-identity` — confirmed authenticated as IAM user with AdministratorAccess, ready to run terraform init/plan on backend bootstrap

## GitHub Actions Basics

- [ ] Not Started — Create repo `.github/workflows/` directory structure
- [ ] Not Started — Write a basic workflow triggered on push (equivalent of Jenkins UI tour / first Freestyle job) — *note: no Jenkins server install/UI tour needed; GitHub Actions runners are hosted, not self-managed*
- [ ] Not Started — Configure workflow to check out code (`actions/checkout`)
- [x] Reviewed/Translated — Install build tools (Java/Maven, Node/npm) via `setup-java` / `setup-node` actions — *note: replaces manual Maven plugin config and manual node/npm install inside Jenkins container. This Jenkins step (Maven Global Tool Config, manual Node.js install via `docker exec`, Pipeline Stage View plugin) has no direct GitHub Actions equivalent because GitHub Actions runners are ephemeral and pre-provisioned — ships with `actions/setup-java` and `actions/setup-node` instead of persistent server configuration.*
  - *Personal notes reviewed (local PDF, not committed) confirming original steps used Maven 3.9.9, Node 20.x, Jenkins Stage View plugin — none of which require replication; GitHub Actions replaces the whole workflow with two setup-action lines.*
- [ ] Not Started — Configure job to run tests and build Java application
- [ ] Not Started — Configure job to run tests and build Node application (if applicable)

## Docker Integration

- [ ] Not Started — Add Docker build step to workflow
- [ ] Not Started — Configure AWS credentials step for ECR — *note: using AWS OIDC instead of static credentials, and ECR instead of DockerHub*
- [ ] Not Started — Create ECR repository via Terraform — *note: using ECR instead of DockerHub/Nexus*
- [ ] Not Started — Push Docker image to ECR — *note: using ECR instead of DockerHub/Nexus*
- [ ] Not Started — Tag image appropriately (commit SHA / semantic version)

## Complete Pipeline

- [ ] Not Started — Build jar/artifact
- [ ] Not Started — Build Docker image
- [ ] Not Started — Push image to ECR — *note: using ECR instead of DockerHub*
- [ ] Not Started — Chain steps into a single end-to-end workflow (equivalent of Jenkins full Pipeline job)
- [ ] Not Started — Add branch-based logic to workflow (equivalent of Jenkins Multibranch job) — *note: using GitHub Actions branch filters / `if: github.ref` conditions instead of Jenkins Multibranch Pipeline job type*

## Credentials & Secrets

- [ ] Not Started — Store AWS credentials as GitHub Encrypted Secrets (interim) — *note: temporary; will migrate to AWS OIDC per CLAUDE.md*
- [ ] Not Started — Set up AWS OIDC identity provider + IAM role in Terraform — *note: using AWS OIDC instead of static AWS keys or Jenkins Credentials store*
- [ ] Not Started — Update workflow to use OIDC federated auth instead of stored keys — *note: replaces Jenkins Credentials UI entirely*
- [ ] Not Started — Remove any interim static AWS keys from GitHub Secrets once OIDC is verified working

## Reusable Workflows

- [ ] Not Started — Identify logic to extract into a reusable workflow (equivalent of Jenkins Shared Library) — *note: GitHub Actions reusable workflows / composite actions replace Jenkins Shared Libraries; implementation model differs (YAML/JS vs Groovy)*
- [ ] Not Started — Create reusable workflow file (`workflow_call` trigger)
- [ ] Not Started — Parameterize reusable workflow with inputs
- [ ] Not Started — Reference reusable workflow from section 08 pipeline
- [ ] Not Started — (Optional) Extract shared logic into a composite action instead, if more appropriate than a reusable workflow

## Webhooks/Triggers

- [ ] Not Started — Confirm native `on: push` / `on: pull_request` triggers are configured — *note: no manual webhook wiring needed; GitHub Actions triggers are native, unlike Jenkins' webhook setup*
- [ ] Not Started — Add `workflow_dispatch` trigger for manual runs
- [ ] Not Started — Add `workflow_dispatch` teardown workflow for AWS resource destruction — *note: new requirement from CLAUDE.md, not part of original Jenkins course*

## Versioning

- [ ] Not Started — Increment version locally with build tool (Maven build-helper plugin or equivalent)
- [ ] Not Started — Increment version as part of GitHub Actions workflow
- [ ] Not Started — Update Dockerfile/build config to reflect versioning changes
- [ ] Not Started — Commit version bump back to repo from workflow
- [ ] Not Started — Prevent the automated version-bump commit from re-triggering the pipeline — *note: use `[skip ci]` in commit message (GitHub Actions native) instead of Jenkins' commit-author-check approach*
