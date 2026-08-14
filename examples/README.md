# Examples

## website

Rebuilds and deploys the `{pkgdown}` site on demand. The `website` job in the standard `Package checks` workflow only runs on push/PR/schedule, so this workflow gives you a way to trigger a site rebuild by hand (for example, while debugging a rendering problem) without pushing a commit or re-running the full check matrix.

### Usage

```r
usethis::use_github_action(
  url = file.path(
    "https://raw.githubusercontent.com/rstudio/shiny-workflows",
    "main/examples/website.yaml"
  )
)
```

Then trigger it from the **Actions** tab (*Website* → *Run workflow*), or via the API:

```bash
gh workflow run website.yaml
```

The workflow is trigger-only (`workflow_dispatch` / `repository_dispatch`), so it does not duplicate the site build that already happens on push. It accepts the same parameters as `website.yaml`; add a `with:` block to the `website` job to set them.

## lock-threads

This action uses the [lock-threads](https://github.com/marketplace/actions/lock-threads) action to lock issues and pull requests that have been inactive for a specified period of time.

### Usage

```r
usethis::use_github_action(
  url = file.path(
    "https://raw.githubusercontent.com/rstudio/shiny-workflows",
    "main/examples/lock-threads.yaml"
  )
)
```

If desired, update the YAML file to change the default settings. By default, this workflow will lock **closed** issues when they've been inactive for 60 days. To enable locking of pull requests, set the `process-only` input to `'prs'` or `''` to lock both issues and pull requests.

```yaml
jobs:
  lock-threads:
    uses: rstudio/shiny-workflows/.github/workflows/lock-threads.yaml@v1
    with:
      # Lock issues and pull requests that have been inactive for 30 days
      issue-inactive-days: 30
      pr-inactive-days: 30
      # Lock both issues and pull requests
      process-only: ''
```

The workflow runs [once a week at 5:42 AM UTC on Monday](https://crontab.guru/#42_5_*_*_1). To change the schedule, update the `cron: '42 5 * * 1'` option in the YAML file.
