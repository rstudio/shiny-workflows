# setup-macOS-dependencies

<!-- [![RStudio community](https://img.shields.io/badge/community-github--actions-blue?style=social&logo=rstudio&logoColor=75AADB)](https://community.rstudio.com/new-topic?category=Package%20development&tags=github-actions) -->

This action installs all macOS dependencies using brew.

Known dependencies:
* `Cairo`:
  * `brew install --cask xquartz`
  * `brew install cairo`
* `textshaping`:
  * `brew install harfbuzz fribidi`
* `rgeos`:
  * `brew install geos`
* `rgdal`
  * `brew install pkg-config gdal`


# Usage

```yaml
steps:
- uses: actions/checkout@v2
- uses: r-lib/actions/setup-r@v1
- uses: rstudio/shiny-workflows/setup-macOS-dependencies@v1
  with:
    needs: check
    extra-packages: rcmdcheck
- uses: r-lib/actions/setup-r-dependencies@v1
  with:
    extra-packages: rcmdcheck
- uses: r-lib/actions/check-r-package@v1
```

# License

The scripts and documentation in this project are released under the [MIT License](LICENSE)

# Contributions

Contributions are welcome!
