# Reusable GHA workflows

:triangular_flag_on_post::triangular_flag_on_post::triangular_flag_on_post: This repo is intended for internal use only. Sweeping change may (and will) be made without notice. :triangular_flag_on_post::triangular_flag_on_post::triangular_flag_on_post:

A reusable workflow is a workflow that is defined in a single location but can be executed from another location as if it was locally defined. Link: https://docs.github.com/en/actions/learn-github-actions/reusing-workflows

## Usage:

This workflow below should be copied into your repo at **./github/workflows/R-CMD-check.yaml**

```yaml
# Workflow derived from https://github.com/rstudio/shiny-workflows
# Need help debugging build failures? Start at https://github.com/r-lib/actions#where-to-find-help
#
# NOTE: This Shiny team GHA workflow is overkill for most R packages.
# check-standard.yaml is likely a better choice.
# `usethis::use_github_action("check-standard")` will install it.
on:
  push:
    branches: [main, rc-**]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 8 * * 1' # every monday

name: Package checks

jobs:
  website:
    uses: rstudio/shiny-workflows/.github/workflows/website.yaml@v1
  routine:
    uses: rstudio/shiny-workflows/.github/workflows/routine.yaml@v1
  R-CMD-check:
    uses: rstudio/shiny-workflows/.github/workflows/R-CMD-check.yaml@v1
```

> Note: Adjust the `8` in the schedule to match the number of letters in the package name to insert some time variance. This helps mitigate PAT rate limits when testing many packages on a schedule.

## Workflows


There are three main reusable workflows to be used by packages in the shiny-verse

* `website.yaml`
  * This is a wrapper for building a `{pkgdown}` website and deploying it to the `gh-pages` branch of the repo.
  * Packages included in the `./DESCRIPTION` field `Config/Needs/website` will also be installed
  * Parameters:
    * `extra-packages`: Installs extra packages not listed in the `./DESCRIPTION` file to be installed. Link: https://github.com/r-lib/actions/tree/v1/setup-r-dependencies
    * `cache-version`: The cache key to be used. Link: https://github.com/r-lib/actions/tree/v1/setup-r-dependencies
    * `pandoc-version`: Sets the pandoc version to be installed. Link: https://github.com/r-lib/actions/tree/master/setup-pandoc
    * `check-title`: If set, will disable `rmarkdown`'s check for having the vignette title and the document title match
* `routine.yaml`
  * Performs many common tasks for packages in the shiny-verse
    * Check for url redirects in `rc-v**` branches
    * `devtools::document()`
    * `devtools::build_readme()` (if `./README.Rmd` exists)
    * Calls `yarn build` and commits any changes in `./inst`, `./srcts`, and `./srcjs`.
    * Pushes any new git commits to the repo
    * Checks code coverage with `covr` if `./codecov.yml` exists
    * Checks for broken lints if `./.lintr` exists
    * Calls `yarn test`
  * Packages included in the `./DESCRIPTION` field `Config/Needs/routine` will also be installed
  * Parameters:
    * `extra-packages`, `cache-version`, `pandoc-version`: Same as in `website.yaml`
    * `node-version`: Version of `node.js` to install
* `R-CMD-check.yaml`
  * Performs `R CMD check .` on your package
  * Parameters:
    * `extra-packages`, `cache-version`, `pandoc-version`: Same as in `website.yaml`
    * `check-args`: Passed to `args` https://github.com/r-lib/actions/blob/v1/check-r-package/
    * `macOS`: `macOS` runtime to use
    * `windows`: `windows` runtime to use
    * `ubuntu`: `ubuntu` runtime to use. To use more than one ubuntu value, send in a value separated by a space. For example, to test on ubuntu 18 and 20, use `"ubuntu-18.04 ubuntu20.04"`. The first `ubuntu` value will be tested using the `"devel"` R version.

## Customization {#custom}

There are a set of known files that can be run. The file just needs to exist to be run. No extra configuration necessary.

The files must exist in the `./.github/shiny-workflow/` folder. Such as `./.github/shiny-workflow/before-routine-push.R`.

Files:
* `before-install.R` / `before-install.sh`
  * Run in `./setup-r-package` after R is installed, but before the local package dependencies are installed.
* `before-build-site.R` / `before-build-site.sh`
  * Run in `website.yaml` before the site is built
* `before-routine-push.R` / `before-routine-push.sh`
  * Run in `routine.yaml`. Runs before the local commits are pushed back to the repo
* `after-routine-push.R` / `after-routine-push.sh`
  * Run in `routine.yaml`. Runs after the local commits are pushed back to the repo. Useful to execute code that does not produce files that should be commited back to the repo
* `before-check.R` / `before-check.sh`
  * Run in `R-CMD-check.yaml` before any `R CMD check .` are called
* `after-check-success.R` / `after-check-success.sh`
  * Run in `R-CMD-check.yaml` after all `R CMD check .` have not failed
* `after-check-failure.R` / `after-check-failure.sh`
  * Run in `R-CMD-check.yaml` on any failure

These scripts should be done for their side effects, such as copying files or installing dependencies.

For example, a common use case for using a shell script over an R script would be to install custom system dependencies. Since installation is usually **O**perating**S**ystem specific, you'll likely want to make use of System environment variables, such as `$RUNNER_OS`. Link: https://docs.github.com/en/actions/learn-github-actions/environment-variables

Example usage of `before-install.sh`:
``` bash
if [ "$RUNNER_OS" == "macOS" ]; then
  brew install harfbuzz fribidi
fi
```

## Initialization

For my repo, I'd like to...

#### Setup pkgdown to build to `gh-pages`

```r
# Inits `gh-pages` as an orphan branch
# Sets `gh-pages` as the default location to host the repo website
# Ignores `./docs` and pkgdown config
# Inits `_pkgdown.yml` config
#   - When prompted to edit the pkgdown config, please add `url: https://rstudio.github.io/REPO`
# Adds url to DESCRIPTION field
usethis::use_pkgdown_github_pages()

# Remove pkgdown workflow file; (Using reusable workflow definition instead)
unlink(".github/workflows/pkgdown.yaml")

## Commit changes
```



## Where to find help

If your build fails and you are unsure of why, please visit https://github.com/r-lib/actions#where-to-find-help for more debugging tips. If you feel it is an error done by `shiny-workflows`, please submit an issue: https://github.com/rstudio/shiny-workflows/issues/new


## Common questions

1. *Why are my builds failing on macOS?*\
  Please double check that their are no required dependencies stated in the log during installation. If there is an unmet dependency, please make an issue so that other repos may utilize this knowledge: https://github.com/rstudio/shiny-workflows/issues/new
2. *What if my website is custom?*\
  It is ok to comment the `website` job in your workflow file. When the time comes that you can use the standardised `{pkgdown}` workflow, feel free to uncomment the `website` job.



<!-- Copy from https://github.com/r-lib/actions/blob/2a200e6b02be657ea5fc0b65ce8720918757039a/README.md -->
## Additional resources

- [`r-lib/actions`](https://github.com/r-lib/actions).
- [GitHub Actions for R](https://www.jimhester.com/talk/2020-rsc-github-actions/), Jim Hester's talk at rstudio::conf 2020. [Recording](https://resources.rstudio.com/rstudio-conf-2020/azure-pipelines-and-github-actions-jim-hester), [slidedeck](https://speakerdeck.com/jimhester/github-actions-for-r).
- [GitHub Actions advent calendar](https://www.edwardthomson.com/blog/github_actions_advent_calendar.html) a series of blogposts by Edward Thomson, one of the GitHub Actions product managers
  highlighting features of GitHub Actions.
- [GitHub Actions with R](https://ropenscilabs.github.io/actions_sandbox/) - a short online book about using GitHub Actions with R, produced as part of the [rOpenSci OzUnconf](https://ozunconf19.ropensci.org/).
- [Awesome Actions](https://github.com/sdras/awesome-actions#awesome-actions---) - a curated list of custom actions. **Note** many of these are from early in the GitHub Actions beta and may no longer work.
<!-- End - Copy from https://github.com/r-lib/actions/blob/2a200e6b02be657ea5fc0b65ce8720918757039a/README.md -->


## `shiny-workflow` development

If updates are made to the workflows, the `v1` tag must be (forcefully) moved forward to the latest value within the `rstudio/shiny-workflows`. To do this, run:

``` bash
git tag -f v1
git push origin --tags -f
```

## License ![CC0 licensed](https://img.shields.io/github/license/r-lib/actions)

All examples in this repository are published with the [CC0](./LICENSE) license.
