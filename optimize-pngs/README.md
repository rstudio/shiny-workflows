# optimize-pngs

## Losslessly optimize PNGs with oxipng

This GitHub Action losslessly optimizes the PNG files tracked in your repository using [`oxipng`](https://github.com/oxipng/oxipng), and commits the result. Pixels are never altered; only the PNG encoding and non-essential metadata change, so images render identically while the package tarball gets smaller.

Only files that are **tracked by git** are considered, so generated build artifacts are left alone.

## Inputs

| Input             | Description                                                     | Default                              | Required |
|-------------------|-----------------------------------------------------------------|--------------------------------------|----------|
| version           | Version of `oxipng` to use (e.g., `10.2.0`)                     | `'10.2.0'`                           | No       |
| paths             | Newline-separated git pathspecs of PNG files to optimize        | `man/figures/*.png`, `vignettes/*.png` | No     |
| working-directory | Working directory for the action                                 | `'.'`                                | No       |

## Usage

To use this action in your workflow, add the following step:

```yaml
- name: Optimize PNGs
  uses: rstudio/shiny-workflows/optimize-pngs@v1
```

By default, `optimize-pngs` optimizes PNGs in `man/figures/` and `vignettes/`. Use `paths` to point it somewhere else, one [git pathspec](https://git-scm.com/docs/gitglossary#Documentation/gitglossary.txt-aiddefpathspecapathspec) per line:

```yaml
- name: Optimize PNGs
  uses: rstudio/shiny-workflows/optimize-pngs@v1
  with:
    paths: |
      man/figures/*.png
      vignettes/*.png
      pkgdown/assets/*.png
```

Note that `*` matches `/` in a git pathspec, so nested folders are included: `vignettes/*.png` also matches `vignettes/images/screenshot.png`.

`optimize-pngs` commits all changes back to the repository, so be sure to configure your git user in the workflow:

```yaml
- name: Commit changes
  run: |
    git config --global user.name "$GITHUB_ACTOR"
    git config --global user.email "$GITHUB_ACTOR@users.noreply.github.com"

- name: Optimize PNGs
  uses: rstudio/shiny-workflows/optimize-pngs@v1
```

Set `paths` to `false` (or an empty string) to disable the action without removing it from your workflow.

## `testthat` snapshots are never optimized

Files under a `_snaps/` folder are always skipped, even when a pathspec matches them. `testthat::compare_file_binary()` — which {testthat} and {shinytest2} use to compare snapshots — compares files byte for byte, so optimizing a committed snapshot would keep it from ever matching a freshly generated screenshot.

## Why `oxipng`?

`oxipng` is not packaged in any Ubuntu release, so it is installed from a pinned release binary. Pinning also keeps the optimized output stable across runner image updates, so routine runs do not produce surprise diffs.

Benchmarked over 51 PNGs from {shinytest2} and {bslib} (3.42 MB):

| Tool | Saved | Time |
|------|-------|------|
| `oxipng --opt 4 --strip safe` | **34.1%** | **6.4s** |
| `oxipng --opt max --strip safe` | 34.3% | 33.1s |
| `optipng -o2` | 27.2% | 24s |
| `optipng -o7` | 27.3% | 372s |
| `advpng -z4` | 31.8% | 699s |
| `zopflipng` | — | did not finish in 10 min |
| `ECT -3 -strip` | 35.8% | 21s (no Linux binary published) |

## Supported runners

Linux and macOS. Windows runners are not supported, as `oxipng` publishes a `.zip` rather than the `.tar.gz` this action installs; the action fails with a clear error there.
