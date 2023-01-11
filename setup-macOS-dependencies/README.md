# setup-macOS-dependencies

<!-- [![RStudio community](https://img.shields.io/badge/community-github--actions-blue?style=social&logo=rstudio&logoColor=75AADB)](https://community.rstudio.com/new-topic?category=Package%20development&tags=github-actions) -->

This action installs all macOS dependencies using brew.

Known dependencies:
* `Cairo`:
  * `brew install --cask xquartz`
  * `brew install cairo`
* `FreeType`:
  * `brew install freetype`
* `textshaping`:
  * `brew install harfbuzz fribidi`
* `rgeos`:
  * `brew install geos`
* `rgdal`:
  * `brew install pkg-config gdal`
* `terra`:
  * `brew install pkg-config proj geos gdal sqlite`
* `units`:
  * `brew install udunits`


# Usage

```yaml
steps:
- uses: actions/checkout@v3
- uses: r-lib/actions/setup-r@v2
- uses: rstudio/shiny-workflows/setup-macOS-dependencies@v1
  with:
    needs: check
    extra-packages: any::rcmdcheck
- uses: r-lib/actions/setup-r-dependencies@v2
  with:
    extra-packages: any::rcmdcheck
- uses: r-lib/actions/check-r-package@v2
```

# License

The scripts and documentation in this project are released under the [MIT License](LICENSE)

# Contributions

Contributions are welcome!
