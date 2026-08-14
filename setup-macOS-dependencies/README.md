# setup-macOS-dependencies

<!-- [![RStudio community](https://img.shields.io/badge/community-github--actions-blue?style=social&logo=rstudio&logoColor=75AADB)](https://community.rstudio.com/new-topic?category=Package%20development&tags=github-actions) -->

This action installs the macOS system dependencies that R package binaries
still need, using brew.

Known dependencies:
* `Cairo`, `grDevices`:
  * `brew install --cask xquartz`

## Why the list is so short

[Posit Public Package Manager](https://packagemanager.posit.co/) and CRAN now
ship macOS binaries for nearly everything, so there is usually no source build
and therefore nothing to link against.
[`setup-r-package`](../setup-r-package) asks for those binaries explicitly on
macOS via `use-public-rspm: always`.

`Cairo` is the exception. Its binary is linked against XQuartz
(`/opt/X11/lib/libXrender.1.dylib`), which the GitHub runner image does not
provide, so it installs cleanly and then fails to load. Installing XQuartz also
restores `capabilities("X11")`.

These entries used to be in the list and have been removed:

| Package | Why it was dropped |
| --- | --- |
| `FreeType` | Not on CRAN at all — no source, no archive |
| `RMySQL` | CRAN ships a macOS binary; loads without `mariadb-connector-c` |
| `rgdal` | Archived from CRAN |
| `rgeos` | Archived from CRAN |
| `terra` | PPM ships a macOS binary |
| `textshaping` | PPM ships a macOS binary |
| `units` | PPM ships a macOS binary |

`cairo`, `harfbuzz` and `fribidi` are already present on the runner image.

This is not taken on faith:
[`.github/workflows/test-integration.yaml`](../.github/workflows/test-integration.yaml)
installs **and loads** each of these packages on every run. Loading is the part
that matters — a binary missing a system library installs fine and only fails
at `dlopen` time.

If `otelsdk` is among the resolved dependencies,
[`r-hub/actions/setup-r-sysreqs`](https://github.com/r-hub/actions/tree/v1/setup-r-sysreqs)
is installed as well.

# Usage

Normally you do not call this directly —
[`setup-r-package`](../setup-r-package) already does.

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
