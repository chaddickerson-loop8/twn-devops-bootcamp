# Section 08: CI/CD with GitHub Actions (rebuilding Jenkins module)

Rebuild of TechWorld with Nana's "Build Automation & CI/CD with Jenkins" module, using GitHub Actions + AWS per [CLAUDE.md](../../CLAUDE.md).

## Intro to Build Automation

- [ ] Not Started — Review build automation concepts (tool-agnostic, no rebuild needed)

## Terraform Foundation

- [x] Done — Write Terraform backend bootstrap config (S3 bucket for state + DynamoDB table for locking) in `terraform-backend/` — *note: this is a one-time manual bootstrap (local state only, no `backend` block — see `terraform-backend/README.md`), not something GitHub Actions runs. Applied successfully and independently verified in the AWS Console: S3 bucket `chaddickerson-twn-devops-tfstate` and DynamoDB table `twn-devops-bootcamp-tfstate-lock` now exist in AWS (see `screenshots/s3-bucket-created-console-view.png` and `screenshots/dynamodb-table-created-console-view.png`).*
- [x] Done — Configure local AWS CLI credentials (aws configure) and verify via `aws sts get-caller-identity` — confirmed authenticated as IAM user with AdministratorAccess, ready to run terraform init/plan on backend bootstrap

## Demo Application

- [x] Done — Add modernized Java 17/Spring Boot 3.2.5 demo app in `app/`, sourced from the TWN course reference repo (`chaddickerson-loop8/Jenkins-GitHub`, `starting-code` branch) and modernized from Java 8/Spring Boot 2.3 per this repo's modernization policy (see root `CLAUDE.md`) — local build verified successful via `mvn clean package` (see `screenshots/maven-build-success-claude-code-output.png`).

## GitHub Actions Basics

- [x] Done — Create repo `.github/workflows/` directory structure — created at repo root (`.github/workflows/`), containing `section08-ci.yml`
- [x] Done — Write a basic workflow triggered on push (equivalent of Jenkins UI tour / first Freestyle job) — *note: no Jenkins server install/UI tour needed; GitHub Actions runners are hosted, not self-managed. `section08-ci.yml` triggers on push to `08-cicd-github-actions` and on `pull_request` targeting `main`.*
- [x] Done — Configure workflow to check out code (`actions/checkout`) — `actions/checkout@v4` step added, replacing Jenkins' Git SCM job configuration
- [x] Reviewed/Translated — Install build tools (Java/Maven, Node/npm) via `setup-java` / `setup-node` actions — *note: replaces manual Maven plugin config and manual node/npm install inside Jenkins container. This Jenkins step (Maven Global Tool Config, manual Node.js install via `docker exec`, Pipeline Stage View plugin) has no direct GitHub Actions equivalent because GitHub Actions runners are ephemeral and pre-provisioned — ships with `actions/setup-java` and `actions/setup-node` instead of persistent server configuration.*
  - *Personal notes reviewed (local PDF, not committed) confirming original steps used Maven 3.9.9, Node 20.x, Jenkins Stage View plugin — none of which require replication; GitHub Actions replaces the whole workflow with two setup-action lines.*
  - *Implemented in `section08-ci.yml`: `actions/setup-java@v4` (temurin, 17) + `actions/setup-node@v4` (20), plus a version-check step (`java -version` / `mvn -version`) mirroring the course's Freestyle job version-verification build step (video 5).*
- [x] Done — Configure job to run tests and build Java application — `section08-ci.yml`'s `build` job runs `mvn clean package` with `working-directory: sections/08-cicd-github-actions/app`, replacing the Freestyle/Maven job's separate `test` and `package` Maven-goal build steps from video 5 (a single `mvn clean package` covers both, since Maven's lifecycle runs `test` before `package`). Added `app/src/test/java/com/example/AppTest.java` (JUnit 5/Jupiter) as part of this, verified locally: `mvn clean package` → BUILD SUCCESS, 1 test run, 0 failures. **Confirmed on GitHub itself**: pushed to `origin/08-cicd-github-actions`, workflow run succeeded (all steps green, `[INFO] BUILD SUCCESS` in the Maven log) — see `screenshots/github-actions-run-success-full-log.png`, `screenshots/mvn-build-success-and-node-warnings-log.png`, `screenshots/mvn-build-step-download-and-success-log.png`. Two non-fatal deprecation warnings noted (GitHub-hosted runner's Node.js 20 deprecation, `actions/setup-java@v4` recommending `@v5`) — did not fail the build; worth bumping actions versions in a later pass.
- [x] N/A — Configure job to run tests and build Node application (if applicable) — no standalone Node application exists in this section's `app/`; the demo app is Java/Spring Boot only, so this item does not apply at this time.

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
