# Terraform Backend Bootstrap

## What this is and why it exists

This config creates the S3 bucket and DynamoDB table that all other Terraform in this section (and later sections) will use as a **remote backend** for state storage and locking.

Remote state matters here specifically because Terraform will be run non-interactively from GitHub Actions workflows, not just from a single developer's machine. Without a shared remote backend:

- State would either live on one local machine, or be recreated fresh (and diverge) on every ephemeral GitHub Actions runner.
- Two runs (e.g. a manual apply and a CI-triggered apply) could stomp on each other's state with no locking.

Storing state in S3 (versioned, encrypted, private) with locking via DynamoDB gives every run — local or CI — a single consistent source of truth for what's already been provisioned.

## This is a ONE-TIME manual bootstrap step

**Do not run this via GitHub Actions. Do not run it repeatedly.**

Apply this config exactly once, locally, using your own AWS credentials. It creates the very backend (the S3 bucket + DynamoDB table) that all subsequent Terraform configs in this repo will point to via a `backend "s3"` block. Once it's applied, it should be left alone — there's nothing else in this section's workflows that should ever re-run `terraform apply` against this specific config.

## The chicken-and-egg problem this solves

Terraform remote state has to live somewhere. If this bootstrap config itself tried to use the S3 backend it's creating, it would need that backend to already exist before it could run — which is impossible on the first run.

To break that cycle, this config intentionally has **no `backend` block** and uses **plain local state** (a `terraform.tfstate` file on your machine, not committed — see the repo-level `.gitignore`). Its only job is to stand up the bucket and table; nothing else in this section should ever add a backend block here.

## Before applying

1. Edit `variables.tf` (or pass `-var`) and replace the placeholder bucket name `REPLACE_ME-twn-devops-bootcamp-tfstate` with a real, globally-unique S3 bucket name.
2. Confirm you're using your own AWS credentials (not CI credentials — this step is manual/local only).
3. Run `terraform init`, `terraform plan`, `terraform apply` yourself, locally, once.
4. Take note of the resulting bucket name and DynamoDB table name (from the outputs) — later Terraform configs in this repo will need them in their own `backend "s3"` blocks.
