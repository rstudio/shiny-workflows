# Examples

Copy-and-adopt workflow files for consumer repos. Every example can be installed with `usethis::use_github_action(url = ...)`, and every example can be triggered by hand from the **Actions** tab (*Run workflow*) or with `gh workflow run <file>`.

**Start with [`pkg-r.yaml`](./pkg-r.yaml)**, which runs the website, routine, and `R CMD check` workflows together. Split any of them out into their own file — [`website.yaml`](./website.yaml), [`routine.yaml`](./routine.yaml), [`R-CMD-check.yaml`](./R-CMD-check.yaml) — when you want it on its own triggers, and remove the matching job from `pkg-r.yaml` so the work isn't done twice.

## pkg-r

The standard shiny-verse workflow: builds the `{pkgdown}` site, runs the routine housekeeping tasks, and runs `R CMD check` across the full matrix, on every push and pull request.

### Usage

```r
usethis::use_github_action(
  url = file.path(
    "https://raw.githubusercontent.com/rstudio/shiny-workflows",
    "main/examples/pkg-r.yaml"
  )
)
```

Each job accepts the same parameters as the workflow it calls; add a `with:` block to set them.

## R-CMD-check

Runs the `R CMD check` matrix as its own workflow, rather than as the `R-CMD-check` job inside `Package checks`. Useful when you want to re-run just the check matrix on demand, or on different triggers than the rest of the checks.

### Usage

```r
usethis::use_github_action(
  url = file.path(
    "https://raw.githubusercontent.com/rstudio/shiny-workflows",
    "main/examples/R-CMD-check.yaml"
  )
)
```

**Remove the `R-CMD-check` job from your `Package checks` workflow when you adopt this file**, otherwise the matrix runs twice on every push.

The workflow accepts the same parameters as `R-CMD-check.yaml`; add a `with:` block to the `R-CMD-check` job to set them.

## routine

Runs the routine housekeeping tasks (air formatting, `usethis::use_tidy_description()`, `devtools::document()`, `build_readme()`, covr, lintr, npm/yarn build and test, staticimports) as its own workflow.

Routine only commits its results back on `pull_request` events from a non-forked branch. On `push` events it verifies that nothing needed to change and fails if something did.

### Usage

```r
usethis::use_github_action(
  url = file.path(
    "https://raw.githubusercontent.com/rstudio/shiny-workflows",
    "main/examples/routine.yaml"
  )
)
```

**Remove the `routine` job from your `Package checks` workflow when you adopt this file**, otherwise the tasks run twice on every push.

The workflow accepts the same parameters as `routine.yaml`; add a `with:` block to the `routine` job to set them.

## website

Builds and deploys the `{pkgdown}` site as its own workflow, rather than as the `website` job inside `Package checks`. The site is still built on every push and pull request, and it can additionally be rebuilt on demand (for example, while debugging a rendering problem) without pushing a commit or re-running the full check matrix.

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

**Remove the `website` job from your `Package checks` workflow when you adopt this file**, otherwise the site is built twice on every push.

The workflow accepts the same parameters as `website.yaml`; add a `with:` block to the `website` job to set them.

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
