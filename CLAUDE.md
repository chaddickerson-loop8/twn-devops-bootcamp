# CLAUDE.md

## Role

This repository rebuilds TechWorld with Nana's DevOps Bootcamp "Build Automation & CI/CD" module using a different tool mapping than the original course:

- **GitHub Actions** instead of Jenkins (no Jenkins server, no Freestyle/Pipeline jobs, no Jenkinsfile)
- **AWS** instead of DigitalOcean (no Droplets; infrastructure lives in AWS)
- **AWS ECR** instead of DockerHub/Nexus for container image storage

When implementing a checklist item from the original course, translate the underlying CI/CD concept (build automation, pipeline-as-code, credential handling, versioning, etc.) to its GitHub Actions / AWS equivalent rather than replicating Jenkins-specific mechanics (Freestyle jobs, Shared Libraries, Jenkins Credentials UI, etc.).

## Security

- **No secrets in code.** Never commit API keys, access keys, tokens, passwords, `.env` files, or kubeconfig/terraform state containing credentials.
- **Short-term:** use GitHub Encrypted Secrets (repo or environment-scoped) for any credential a workflow needs.
- **Migration target:** once the module reaches AWS integration, replace GitHub Encrypted Secrets holding AWS credentials with **AWS OIDC federation** (`aws-actions/configure-aws-credentials` using an OIDC role, not static access keys). No long-lived AWS access keys should exist in GitHub Secrets past that point.
- Treat any credential leak (even in a since-deleted commit) as requiring rotation, not just removal — git history retains it.

## Cost Management

- All AWS resources are provisioned via **Terraform**.
- Nothing runs persistently. After each working session, resources are destroyed via a **manual `workflow_dispatch` teardown workflow**.
- Do not add resources that run outside Terraform's management (manually clicked-up console resources) — they won't be caught by the teardown workflow and will leak cost.
- Before ending a session that provisioned AWS infrastructure, confirm the teardown workflow has been run (or explicitly flag to the user that teardown is still pending).

## Git Workflow

- Branch flow: `develop` → section branches → PR review → merge to `develop` → PR review → merge to `main`.
- **No direct pushes to `main`.** All changes to `main` land via reviewed PR from `develop`.
- **No direct pushes to `develop`** either — section work happens on section branches, merged via PR.
- **No AI-attribution in commits or PRs** — no "Co-Authored-By: Claude" or similar trailers, no mention of AI assistance in commit messages or PR descriptions.

## Registry

- Use **AWS ECR** for all container image storage. Do not reference DockerHub or Nexus in new workflows — those were the original course's registries and are not part of this rebuild's target architecture.
