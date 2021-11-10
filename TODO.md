# DONE
* √ Rename commits to represent the command it is doing
* √ devtools::document() instead of roxygenize
* √ Remove re-upping staticimports. Instead use warning on file if an update exists. Then back out of changes. Move to end
* √ When building js, also add the `srcjs` folder
* √ Make description to put in the workflow template
* √ Move callable workflows to a new repo
* √ Convert R-CMD-check `config` generation to use R/python, something easier to reason about
* √ How should --donttest be handled? Use `args` in an extra R-CMD-check job
* √ Remove netlify workflow
* √ More verbose step names; use the command
* √ auto install tinytex if present in DESCRIPTION file
* √ Rename script `website-build` to `website`
* √ Move `check-args` to `extra-check-args` and implement concat logic to avoid needing the regular args
* √ Update phrasing for top comment

# TODO
* Move description version to package.json logic from here to within shiny's `yarn build`
