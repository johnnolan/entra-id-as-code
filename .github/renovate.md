# Renovate configuration

This document explains the configuration in `.github/renovate.json` and the security and maintenance choices behind it.

## What the file does

Renovate manages dependency updates for the repository using a configuration designed to keep the update flow predictable, grouped, and easy to review. It covers Terraform providers and GitHub Actions, which are the main dependency surfaces in this repository.

## Base configuration

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "config:recommended",
    "helpers:pinGitHubActionDigests"
  ],
  "enabledManagers": [
    "terraform",
    "github-actions"
  ],
  "timezone": "Etc/UTC",
  "schedule": [
    "* 4-7 * * 1"
  ],
  "prConcurrentLimit": 5,
  "semanticCommits": "enabled",
  "semanticCommitType": "chore",
  "semanticCommitScope": "deps",
  "labels": [
    "dependencies",
    "security"
  ]
}
```

### Recommended defaults

The repository extends the Renovate `config:recommended` preset, which applies the baseline best-practice settings for dependency management. It also enables the `helpers:pinGitHubActionDigests` helper to pin GitHub Actions to immutable digests instead of floating tag references.

This is useful for security and reproducibility because it reduces the chance of unexpected upstream changes affecting the workflow environment.

### Manager scope

Renovate is enabled only for:

- `terraform`
- `github-actions`

This keeps the dependency automation focused on the package ecosystems used in the repository and avoids broad, unrelated update coverage.

### Time and cadence

The timezone is set to `Etc/UTC`, and the schedule is `* 4-7 * * 1`. This means Renovate runs during the Monday morning window in UTC, between 04:00 and 07:00. The schedule is deliberately narrow and weekly, which keeps updates regular without overwhelming maintainers.

### Pull request flow

The configuration sets `prConcurrentLimit` to `5`. This limits how many open dependency pull requests Renovate can create at the same time.

The repository also uses semantic commit conventions for dependency changes:

- commit type: `chore`
- scope: `deps`

This gives dependency update commits a predictable format, which helps review and changelog-style filtering.

## Package rules

```json
"packageRules": [
  {
    "description": "Group Terraform provider updates",
    "matchManagers": [
      "terraform"
    ],
    "matchDatasources": [
      "terraform-provider"
    ],
    "groupName": "Terraform providers",
    "groupSlug": "terraform-providers",
    "addLabels": [
      "terraform"
    ]
  },
  {
    "description": "Label GitHub Actions updates",
    "matchManagers": [
      "github-actions"
    ],
    "addLabels": [
      "github-actions"
    ]
  },
  {
    "description": "Group non-major GitHub Actions updates",
    "matchManagers": [
      "github-actions"
    ],
    "matchUpdateTypes": [
      "minor",
      "patch",
      "digest",
      "pinDigest"
    ],
    "groupName": "GitHub Actions non-major updates",
    "groupSlug": "github-actions-non-major"
  }
]
```

### Terraform provider grouping

Terraform provider updates are grouped under `Terraform providers`. This helps maintainers review provider changes together instead of receiving isolated updates across multiple provider sources.

The rule adds the `terraform` label, which makes it easy to find these updates in pull request filters and dashboards.

### GitHub Actions labeling

GitHub Actions updates get the `github-actions` label. This makes workflow automation changes easy to filter from Terraform or other updates.

### Non-major GitHub Actions grouping

The `github-actions-non-major` group bundles `minor`, `patch`, `digest`, and `pinDigest` updates. This reduces the review burden for routine workflow maintenance while still allowing major version changes to be reviewed separately as a higher-risk category.

> [!IMPORTANT]
> This configuration deliberately groups routine dependency work to reduce operation overhead while preserving clear review boundaries. It also applies a `security` label to all updates, which helps maintainers prioritise security-sensitive dependency changes.

## Why this configuration is useful

This setup supports a practical security and maintenance model:

- dependency updates stay within the ecosystems the repo actually uses;
- provider updates are grouped to keep Terraform changes reviewable;
- GitHub Actions updates are grouped by risk profile and labeled clearly;
- weekly, time-boxed updates reduce churn while still keeping the repo current;
- pinned action digests improve workflow reproducibility and reduce supply-chain risk.

In short, the config balances safety, predictability, and reviewability without introducing unnecessary update noise.
