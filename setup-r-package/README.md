# setup-r-package

<!-- [![RStudio community](https://img.shields.io/badge/community-github--actions-blue?style=social&logo=rstudio&logoColor=75AADB)](https://community.rstudio.com/new-topic?category=Package%20development&tags=github-actions) -->

This action should be your "go-to" action to install a package and all necessary dependencies.

This action installs `pandoc`, `R`, `macOS` and `Linux` system dependencies, package dependencies and extra packages, and `phantomJS`.



# Usage

```yaml
steps:
- uses: actions/checkout@v2
- uses: rstudio/shiny-workflows/setup-r-package@v1
  with:
    extra-packages: any::rcmdcheck
- uses: r-lib/actions/check-r-package@v2
```

# License

The scripts and documentation in this project are released under the [MIT License](LICENSE)

# Contributions

Contributions are welcome!
