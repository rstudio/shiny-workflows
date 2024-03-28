# setup-phantomjs

<!-- [![RStudio community](https://img.shields.io/badge/community-github--actions-blue?style=social&logo=rstudio&logoColor=75AADB)](https://community.rstudio.com/new-topic?category=Package%20development&tags=github-actions) -->

This action should be used within `rstudio/shiny-workflows/setup-r-package`

This action installs `phantomJS` if-and-only-if `shinytest` or `webdriver` are a direct R package dependency.

If `shinytest` is installed, the local package will also be installed for background R session testing to work properly.

# Usage

```yaml
steps:
- uses: actions/checkout@v4
# `setup-r-package` calls `setup-phantomjs`
- uses: rstudio/shiny-workflows/setup-r-package@v1
  with:
    extra-packages: any::rcmdcheck
- uses: r-lib/actions/check-r-package@v2
```

# License

The scripts and documentation in this project are released under the [MIT License](LICENSE)

# Contributions

Contributions are welcome!
