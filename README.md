# Reusable GHA workflows

:triangular_flag_on_post::triangular_flag_on_post::triangular_flag_on_post: This repo is intended for internal use only. Sweeping changes will be made without notice. :triangular_flag_on_post::triangular_flag_on_post::triangular_flag_on_post:

A reusable workflow is a workflow that is defined in a single location but can be executed from another location as if it was locally defined. Link: https://docs.github.com/en/actions/learn-github-actions/reusing-workflows

## Usage:

This workflow below should be copied into your repo at **.github/workflows/R-CMD-check.yaml**

```yaml
# Workflow derived from https://github.com/rstudio/shiny-workflows
#
# NOTE: This Shiny team GHA workflow is overkill for most R packages.
# For most R packages it is better to use https://github.com/r-lib/actions
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
  * Packages included in the `DESCRIPTION` field `Config/Needs/website` will also be installed
  * Parameters:
    * `extra-packages`: Installs extra packages not listed in the `DESCRIPTION` file to be installed. Link: https://github.com/r-lib/actions/tree/v2/setup-r-dependencies
    * `cache-version`: The cache key to be used. Link: https://github.com/r-lib/actions/tree/v2/setup-r-dependencies
    * `pandoc-version`: Sets the pandoc version to be installed. Link: https://github.com/r-lib/actions/tree/master/setup-pandoc
    * `check-title`: If set, will disable `rmarkdown`'s check for having the vignette title and the document title match
* `routine.yaml`
  * Performs many common tasks for packages in the shiny-verse and commits them back to the repo
    * Check for url redirects in `rc-v**` branches
    * `devtools::document()`
    * `devtools::build_readme()` (if `README.Rmd` exists)
    * Calls `yarn build` and commits any changes in `inst`, `srcts`, and `srcjs`.
    * Checks code coverage with `covr` if `codecov.yml` exists
    * Checks for broken lints if `.lintr` exists
    * Calls `yarn test`
    * Checks for outdated `staticimports`
  * Packages included in the `DESCRIPTION` field `Config/Needs/routine` will also be installed
  * Parameters:
    * `extra-packages`, `cache-version`, `pandoc-version`: Same as in `website.yaml`
    * `node-version`: Version of `node.js` to install
    * `staticimports`: Determines if `staticimports` should display a warning message if the staticimports are out of date.
    * `minimize-man-figures`: If any PNG images are found in `man/figures`, then the images are attempted to be minimized using `optipng`. This is useful for reducing the size of the package tarball without losing quality. Set to `false` to disable image minimization.
* `R-CMD-check.yaml`
  * Performs `R CMD check .` on your package
  * Parameters:
    * `extra-packages`, `cache-version`, `pandoc-version`: Same as in `website.yaml`
    * `extra-check-args`: Arguments passed in addition to the default check `args` of https://github.com/r-lib/actions/blob/v2/check-r-package/
    * `macOS`: `macOS` runtime to use. Set to `false` to disable testing on macOS.
    * `windows`: `windows` runtime to use. Set to `false` to disable testing on Windows.
    * `ubuntu`: `ubuntu` runtime to use. To use more than one ubuntu value, send in a value separated by a space. For example, to test on ubuntu 18 and 20, use `"ubuntu-18.04 ubuntu20.04"`. The first `ubuntu` value will be tested using the `"devel"` R version. Set to `false` to disable testing on Ubuntu.
    * `minimum-r-version`: If provided, only R versions >= to `minimum-r-version` will be created in the matrix. Great for dependencies that will not install on earlier R versions.
    * `rtools-35`: If `false`, packages with a `src` folder will not test on Windows R 3.6 using `rtools35`.

## Customization

There are a set of known files that can be run. The file just needs to exist to be run. No extra configuration necessary.

The files must exist in the `.github/shiny-workflows/` folder. Such as `.github/shiny-workflows/package-install.R`.

Files:
* `package-install.R` / `package-install.sh`
  * This step is run in **all** workflows after R is installed, but before the local package dependencies are installed.
  * This script could be useful for installing custom dependencies
* `website.R` / `website.sh`
  * Run in `website.yaml` before the site is built
  * This script could be useful for copying assets to a directory
* `routine.R` / `routine.sh`
  * Run in `routine.yaml`. Runs before the local commits are pushed back to GitHub
  * This script could be useful for running some logic on a single OS and **push the results back** to GitHub
  * This script could be useful for running a test that needs to be performed **once** and not on every job of `R-CMD-check.yaml`


These scripts should be done for their side effects, such as copying files or installing dependencies.

For example, a common use case for using a shell script over an R script would be to install custom system dependencies. Since installation is usually **O**perating**S**ystem specific, you'll likely want to make use of System environment variables, such as `$RUNNER_OS`. Link: https://docs.github.com/en/actions/learn-github-actions/environment-variables

Example usage of `package-install.sh`:
``` bash
if [ "$RUNNER_OS" == "macOS" ]; then
  brew install harfbuzz fribidi
fi
```

## `pkgdown` setup

Typically when using `pkgdown` in a package, you run the command below to initalize all necessary configs.

```r
# Init pkgdown webs
usethis::use_pkgdown_github_pages()
```

However, we will need to remove the GHA workflow file created, as we will use the `website.yaml` reusable `shiny-workflow`.

```r
# Remove pkgdown workflow file; (Using reusable shiny-workflow)
unlink(".github/workflows/pkgdown.yaml")
```



## Where to find help

If your build fails and you are unsure of why, please visit https://github.com/r-lib/actions#where-to-find-help for more debugging tips. If you feel it is an error done by `shiny-workflows`, please submit an issue: https://github.com/rstudio/shiny-workflows/issues/new

<!-- Copy from https://github.com/r-lib/actions/blob/2a200e6b02be657ea5fc0b65ce8720918757039a/README.md -->
### Additional resources

- [`r-lib/actions`](https://github.com/r-lib/actions)
- [GitHub Actions for R](https://www.jimhester.com/talk/2020-rsc-github-actions/), Jim Hester's talk at rstudio::conf 2020. [Recording](https://resources.rstudio.com/rstudio-conf-2020/azure-pipelines-and-github-actions-jim-hester), [slidedeck](https://speakerdeck.com/jimhester/github-actions-for-r).
- [GitHub Actions advent calendar](https://www.edwardthomson.com/blog/github_actions_advent_calendar.html) a series of blogposts by Edward Thomson, one of the GitHub Actions product managers
  highlighting features of GitHub Actions.
- [GitHub Actions with R](https://ropenscilabs.github.io/actions_sandbox/) - a short online book about using GitHub Actions with R, produced as part of the [rOpenSci OzUnconf](https://ozunconf19.ropensci.org/).
- [Awesome Actions](https://github.com/sdras/awesome-actions#awesome-actions---) - a curated list of custom actions. **Note** many of these are from early in the GitHub Actions beta and may no longer work.
<!-- End - Copy from https://github.com/r-lib/actions/blob/2a200e6b02be657ea5fc0b65ce8720918757039a/README.md -->

## Common questions

1. *Why are my builds failing on macOS?*\
  Please double check that their are no required dependencies stated in the log during installation. If there is an unmet dependency, please make an issue so that other repos may utilize this knowledge: https://github.com/rstudio/shiny-workflows/issues/new
2. *What if my website is custom?*\
  It is ok to comment the `website` job in your workflow file. When the time comes that you can use the standardised `{pkgdown}` workflow, feel free to uncomment the `website` job.


## `shiny-workflow` development

### Adopting a feature

Reasons to consider a feature:
* If more than two repos needs custom work, it should be considered.
* If all other repos could benefit from an installation step, even if they are currently not utilized. (Ex: phantomJS, tinytex)

Reasons to NOT consider a feature:
* Trying to appease a single repo. General response: The repo can run more compute cycles / jobs to meet their needs
* The feature imposes behavior that no other repos are performing or willing to adopt. Ex: Automatically setting the package version in `package.json`

### Updates to workflows or actions

If updates are made to the workflows, the `v1` tag must be (forcefully) moved forward to the latest value within the `rstudio/shiny-workflows`. To do this, run:

``` bash
git tag -f v1
git push origin --tags -f
```



## License ![CC0 licensed](https://img.shields.io/github/license/r-lib/actions)

All examples in this repository are published with the [CC0](./LICENSE) license.
