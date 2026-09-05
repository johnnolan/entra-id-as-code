# Dependabot configuration

This document explains the configuration in `.github/dependabot.yml` and why the repository uses it.

## What the file does

Dependabot keeps dependency updates for the repository's Terraform and GitHub Actions files. It checks for updates on a weekly schedule, groups related dependency updates together, and applies labels that make review and triage easier.

## Update settings

### Terraform updates

```yaml
- package-ecosystem: "terraform"
  directory: "/terraform"
  schedule:
    interval: "weekly"
    day: "monday"
    time: "05:00"
    timezone: "Etc/UTC"
  target-branch: "main"
  open-pull-requests-limit: 5
  labels:
    - "dependencies"
    - "terraform"
    - "security"
  commit-message:
    prefix: "chore(deps)"
    include: "scope"
```

This configuration tells Dependabot to scan the Terraform configuration in `/terraform` once per week. The schedule runs on Monday at 05:00 UTC and targets the `main` branch.

The repository allows up to five open pull requests at a time for Terraform dependency updates. This keeps the update flow manageable while still allowing regular provider and module maintenance.

The labels make the updates easy to filter in pull requests:

- `dependencies` marks the change as a dependency update.
- `terraform` identifies the ecosystem involved.
- `security` helps security review and prioritisation.

The commit message prefix `chore(deps)` keeps the repository history consistent with conventional dependency maintenance changes.

### GitHub Actions updates

```yaml
- package-ecosystem: "github-actions"
  directory: "/"
  schedule:
    interval: "weekly"
    day: "monday"
    time: "05:30"
    timezone: "Etc/UTC"
  target-branch: "main"
  open-pull-requests-limit: 3
  labels:
    - "dependencies"
    - "github-actions"
    - "security"
  commit-message:
    prefix: "chore(deps)"
    include: "scope"
```

This section checks the repository root for workflow updates, including GitHub Actions versions used in CI and deployment automation. It runs on Monday at 05:30 UTC and keeps open pull requests limited to three.

## Grouping rules

### Terraform provider grouping

```yaml
groups:
  terraform-providers:
    patterns:
      - "hashicorp/*"
      - "microsoft/*"
  terraform-modules:
    patterns:
      - "*"
    exclude-patterns:
      - "hashicorp/*"
      - "microsoft/*"
```

Dependabot groups Terraform provider updates together so `hashicorp/*` and `microsoft/*` dependencies land in one reviewable batch. The `terraform-modules` group collects remaining module updates, while excluding the provider namespaces to keep provider and module changes cleanly separated.

### GitHub Actions grouping

```yaml
groups:
  github-actions-minor-patch:
    patterns:
      - "*"
    update-types:
      - "minor"
      - "patch"
```

This keeps minor and patch GitHub Action updates grouped together. It reduces noise from frequent workflow dependency updates and makes maintenance easier to review.

> [!IMPORTANT]
> Security review is a requirement for dependency updates. The configuration labels updates as `security`, which helps maintainers prioritise and review changes that may affect the repository's execution environment.

## Why this configuration is useful

The repository uses a security-first dependency model:

- weekly updates keep dependencies current without excessive churn;
- grouped updates reduce review fatigue;
- labels make dependency work easier to filter and audit;
- the `main` target branch keeps all updates aligned with the default branch policy;
- low pull-request limits control review load and reduce conflict risk.

This configuration gives the repo a predictable dependency update cadence without creating unnecessary operational overhead.
