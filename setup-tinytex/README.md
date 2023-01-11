# setup-tinytex

<!-- [![RStudio community](https://img.shields.io/badge/community-github--actions-blue?style=social&logo=rstudio&logoColor=75AADB)](https://community.rstudio.com/new-topic?category=Package%20development&tags=github-actions) -->

This action should be used within `rstudio/shiny-workflows/setup-r-package`

This action installs `tinytex` if-and-only-if `tinytex` is a direct R package dependency.

# Usage

```yaml
steps:
- uses: actions/checkout@v3
# `setup-r-package` calls `setup-tinytex`
- uses: rstudio/shiny-workflows/setup-r-package@v1
  with:
    extra-packages: any::rcmdcheck
- uses: r-lib/actions/check-r-package@v2
```

# License

The scripts and documentation in this project are released under the [MIT License](LICENSE)

# Contributions

Contributions are welcome!
