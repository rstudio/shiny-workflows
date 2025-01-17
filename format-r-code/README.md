# format-r-code

## Format R code with air

This GitHub Action automatically formats R code using the [air formatter](https://posit-dev.github.io/air), a new, blazing-fast R code formatter from [Posit](https://posit.co).

This action installs the `air` formatter and uses it to format R code in your repository. It can either check if the code is properly formatted or automatically format the code and commit the changes.

## Inputs

| Input    | Description                                      | Default   | Required |
|----------|--------------------------------------------------|-----------|----------|
| version  | Version of air to use (e.g., `0.1.2`)            | `latest`  | No       |
| check    | If `'true'`, only check that R code is formatted | `'false'` | No       |
| path     | Path(s) to check (space-separated string)        | `'.'`     | No       |

## Usage

To use this action in your workflow, add the following step:

```yaml
- name: Format R code
  uses: rstudio/shiny-workflows/format-r-code@v1
```

By default, `format-r-code` formats all R code in the repository. You can configure which directories or files are formatted with the `path` option. For example, the following formats only R files in the `R/` directory and the `app.R` file in the `my-example` Shiny app.

```yaml
- name: Format R code
  uses: rstudio/shiny-workflows/format-r-code@v1
  with:
    path: R/ inst/examples-shiny/my-example/app.R
```

`format-r-code` commits all changes back to the repository, so be sure to configure your git user in the worflow:

```yaml
- name: Commit changes
  run: |
    git config --global user.name "$GITHUB_ACTOR"
    git config --global user.email "$GITHUB_ACTOR@users.noreply.github.com"

- name: Format R code
  uses: rstudio/shiny-workflows/format-r-code@v1
```

On the other hand, if you'd rather check that the R code is already formatted as expected or have the workflow fail, set `check: true`:

```yaml
- name: Format R code
  uses: rstudio/shiny-workflows/format-r-code@v1
  with:
    check: true
```

## Configuring air

The best way to configure `air` for your personal style needs is to use an `air.toml` file in your repository. Read more about [configuring air on the air website](https://posit-dev.github.io/air/configuration.html).

## License

The scripts and documentation in this project are released under the [MIT License](LICENSE)