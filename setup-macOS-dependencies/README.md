# setup-macOS-dependencies (deprecated)

<!-- [![RStudio community](https://img.shields.io/badge/community-github--actions-blue?style=social&logo=rstudio&logoColor=75AADB)](https://community.rstudio.com/new-topic?category=Package%20development&tags=github-actions) -->

> [!WARNING]
> **This action is deprecated and will be removed in a future release.**
> It still works exactly as before, and emits a deprecation warning when run.
> [`setup-r-package`](../setup-r-package) no longer calls it.
>
> If you would like this helper action kept, please [open an
> issue](https://github.com/rstudio/shiny-workflows/issues/new) so we know it is
> still in use.

## Why it is deprecated

[Posit Public Package Manager](https://packagemanager.posit.co/) now serves
macOS binaries, and
[`r-lib/actions/setup-r`](https://github.com/r-lib/actions/tree/v2/setup-r)
uses them when `use-public-rspm` is enabled. Because the packages below install
as binaries, there are no system dependencies to build against, and running
`brew install` (plus installing `pak` just to resolve the dependency tree) only
made macOS jobs slower.

Note that `setup-r` only honors `use-public-rspm: true` on macOS for
Posit-owned organizations. Set `use-public-rspm: always` to force it elsewhere.

## Migrating

Remove the step. If you have a package that genuinely must be built from source
on macOS and needs a system library, install it from your `package-install.sh`
[local script](../README.md#customization) instead:

```bash
if [ "$RUNNER_OS" == "macOS" ]; then
  brew install harfbuzz fribidi
fi
```

## Current behavior

This action installs macOS dependencies using brew.

Known dependencies:
* `Cairo`, `grDevices`:
  * `brew install libxt`
  * `brew install --cask xquartz`
  * `brew install cairo`
* `FreeType`:
  * `brew install freetype`
* `RMySQL`:
  * `brew install mariadb-connector-c`
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

If `otelsdk` is among the resolved dependencies,
[`r-hub/actions/setup-r-sysreqs`](https://github.com/r-hub/actions/tree/v1/setup-r-sysreqs)
is installed as well.

# Usage

```yaml
steps:
- uses: actions/checkout@v5
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
