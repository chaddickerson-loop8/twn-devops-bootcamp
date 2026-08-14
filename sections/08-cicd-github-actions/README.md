# Section 08: CI/CD with GitHub Actions

Rebuild of TechWorld with Nana's "Build Automation & CI/CD with Jenkins" module using GitHub Actions instead of Jenkins, and AWS ECR instead of DockerHub/Nexus for image storage. See the repo-level [CLAUDE.md](../../CLAUDE.md) for the full role, security, cost, git workflow, and registry rules this section follows.

This README will be updated as work on the section progresses. See [progress.md](./progress.md) for the task-by-task checklist.

## Progress Log

### 2026-08-10
- Configured AWS CLI credentials locally using an existing IAM user with AdministratorAccess (via group membership).
- Verified credentials work with `aws sts get-caller-identity`.
- Terraform backend bootstrap code (S3 bucket + DynamoDB table, in `terraform-backend/`) was written and reviewed, but not yet applied.
- Next step: run `terraform init` / `plan` / `apply` on the backend bootstrap.

### 2026-08-13
- Ran `terraform init` and `terraform plan` on the backend bootstrap (`terraform-backend/`) — reviewed plan showed 5 resources to add, 0 to change, 0 to destroy.
- Ran `terraform apply` — successfully applied. Confirmed resources now exist in AWS:
  - S3 bucket: `chaddickerson-twn-devops-tfstate` (versioning enabled, AES256 encryption, public access blocked)
  - DynamoDB table: `twn-devops-bootcamp-tfstate-lock` (pay-per-request billing)
- Terraform Foundation backend bootstrap task is now fully done.

### 2026-08-13 (verification)
- Independently verified the applied backend by checking the AWS Console directly (not just Terraform output):
  - S3 bucket `chaddickerson-twn-devops-tfstate` confirmed present — see `screenshots/s3-bucket-created-console-view.png`.
  - DynamoDB table `twn-devops-bootcamp-tfstate-lock` confirmed present and Active — see `screenshots/dynamodb-table-created-console-view.png`.

### 2026-08-13 (demo app)
- Added the demo Java/Spring Boot app for section 08's CI/CD pipeline in `app/`, sourced from the TWN course reference repo (`chaddickerson-loop8/Jenkins-GitHub`, `starting-code` branch).
- Modernized from Java 8/Spring Boot 2.3 to Java 17/Spring Boot 3.2.5 per this repo's modernization policy: bumped `maven-compiler-plugin` source/target to 17, `spring-boot-starter-web`/`spring-boot-maven-plugin` to 3.2.5, replaced JUnit 4 with `spring-boot-starter-test` (JUnit 5), bumped `logstash-logback-encoder` to 7.4, and updated the one required `javax.annotation.PostConstruct` → `jakarta.annotation.PostConstruct` import.
- Verified the app builds successfully with `mvn clean package` (BUILD SUCCESS) — see `screenshots/maven-build-success-claude-code-output.png`.

### 2026-08-13 (first GitHub Actions workflow)
- Added `app/src/test/java/com/example/AppTest.java` — a JUnit 5 (Jupiter) unit test verifying `Application.getStatus()` returns `"OK"`, based on the `AppTest.java` shown in the course's "5 - Jenkins Basics Demo - Freestyle Job" video/PDF (originally JUnit 4; modernized to JUnit 5 per this repo's modernization policy). `getStatus()` already existed in `Application.java` from the earlier modernization pass, so no production code change was needed.
- Verified locally: `mvn clean package` inside `app/` → BUILD SUCCESS, 1 test run, 0 failures.
- Created `.github/workflows/section08-ci.yml` at the repo root — the first GitHub Actions workflow for this section. Triggers on push to `08-cicd-github-actions` and on `pull_request` targeting `main`. Job `build` runs on `ubuntu-latest`: checks out code (`actions/checkout@v4`), sets up JDK 17 (`actions/setup-java@v4`, temurin) and Node 20 (`actions/setup-node@v4`), verifies tool versions, then runs `mvn clean package` against `sections/08-cicd-github-actions/app`.
- This workflow directly replaces the Jenkins Freestyle Job / Maven job process from the course video: Jenkins UI job creation → YAML-as-code; Jenkins Git SCM config → `actions/checkout`; Jenkins Global Tool Configuration (Maven/NodeJS plugins) → `setup-java`/`setup-node`; Jenkins's separate `test`/`package` Maven-goal build steps → one `mvn clean package` step.
- Not yet pushed — workflow only actually runs once pushed to GitHub, so it's being reviewed locally first.
