# setup-r-package

<!-- [![RStudio community](https://img.shields.io/badge/community-github--actions-blue?style=social&logo=rstudio&logoColor=75AADB)](https://community.rstudio.com/new-topic?category=Package%20development&tags=github-actions) -->

This action should be your "go-to" action to install a package and all necessary dependencies.

This action installs `pandoc`, `R`, `macOS` and `Linux` system dependencies, package dependencies and extra packages, and `phantomJS`.

## Inputs

| Input | Description | Default | Required |
|-------|-------------|---------|----------|
| `r-version` | R version to be installed | `"release"` | No |
| `http-user-agent` | HTTP user agent to be sent to RSPM | `""` | No |
| `needs` | Name of config to search in `DESCRIPTION` file. Ex: `website` | `""` | No |
| `extra-packages` | Extra packages to be installed | `""` | No |
| `cache-version` | Value to be inserted into the cache key | `"1"` | No |
| `pandoc-version` | Pandoc version to be installed. `"3.x"` installs latest 3.x version, `"2.x"` installs latest 2.x version | `"3.x"` | No |
| `packages` | Packages to install | `"local::., deps::., any::sessioninfo"` | No |
| `rtools-version` | Exact version of Rtools to use. Default uses latest suitable rtools for the given version of R. Set it to `"42"` for Rtools42 | `""` | No |
| `use-public-rspm` | Use the public version of Posit package manager available at https://packagemanager.posit.co/ to serve binaries for Linux and Windows | `"true"` | No |
| `pak-version` | Which pak version to use. Possible values are `"stable"`, `"rc"`, `"devel"`, `"none"`, `"repo"`. See description below for details | `"stable"` | No |
| `extra-repositories` | One or more extra CRAN-like repositories to include in the repos global option | `""` | No |
| `working-directory` | Working directory for the action | `"."` | No |

### pak-version

The `pak-version` input controls which version of pak to use:

- `"stable"`, `"rc"`, `"devel"`: Install pak from the GitHub repository at GitHub Pages
- `"none"`: Skip pak installation. Use this if you want to install pak yourself. Set the `R_LIB_FOR_PAK` environment variable to point to the library where pak is installed
- `"repo"`: Install pak from configured repositories using `install.packages()`. Appropriate on systems that do not have access to the pak repository on GitHub


# Usage

```yaml
steps:
- uses: actions/checkout@v4
- uses: rstudio/shiny-workflows/setup-r-package@v1
  with:
    extra-packages: any::rcmdcheck
- uses: r-lib/actions/check-r-package@v2
```

# License

The scripts and documentation in this project are released under the [MIT License](LICENSE)

# Contributions

Contributions are welcome!
