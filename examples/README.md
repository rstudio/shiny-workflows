# Examples

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
      days-inactive: 30
      # Lock both issues and pull requests
      process-only: ''
```

The workflow runs [once a week at 5:42 AM UTC on Monday](https://crontab.guru/#42_5_*_*_1). To change the schedule, update the `cron: '42 5 * * 1'` option in the YAML file.
