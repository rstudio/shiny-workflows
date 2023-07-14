# lock-threads

This action uses the [lock-threads](https://github.com/marketplace/actions/lock-threads) action to lock issues and pull requests that have been inactive for a specified period of time.

# Usage

```r
usethis::use_github_action(
  url = file.path(
    "https://raw.githubusercontent.com/rstudio/shiny-workflows",
    "main/lock-threads/lock-threads.yaml"
  )
)
```

If desired, update the YAML file to change the default settings. By default, this workflow will lock closed issues when they've been inactive for 60 days. To enable locking of pull requests, comment out or remove the `process-only` option.

The workflow runs [once a day at 5:42 AM UTC](https://crontab.guru/#42_5_*_*_*). To change the schedule, update the `cron: '42 5 * * *'` option in the YAML file.

# License

The scripts and documentation in this project are released under the [MIT License](LICENSE)

# Contributions

Contributions are welcome!
