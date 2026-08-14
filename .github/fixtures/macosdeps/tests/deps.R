# Prove the ex-`brew_list` packages are usable without Homebrew.
#
# Installing them is necessary but not sufficient: a binary that links against
# a missing system library installs fine and then fails to load. Loading each
# namespace is what actually exercises the removed `brew install` steps.

pkgs <- c("Cairo", "terra", "textshaping", "units")

# `RMySQL` has no macOS binary on Posit Public Package Manager, so it is only
# exercised when the workflow adds it via `extra-packages`. The name is held in
# a variable so `R CMD check` does not read it as an unstated dependency --
# adding it to `Suggests` would make every leg install it.
rmysql <- "RMySQL"
if (nzchar(system.file(package = rmysql))) {
  pkgs <- c(pkgs, rmysql)
}

for (pkg in pkgs) {
  cat("Loading ", pkg, " ... ", sep = "")
  stopifnot(requireNamespace(pkg, quietly = TRUE))
  cat("ok (built: ", packageDescription(pkg)[["Built"]], ")\n", sep = "")
}

# `grDevices` was in `brew_list` for libxt / xquartz / cairo. It is a base
# package, so the only way to check that entry is the capability it provided.
cat("capabilities('cairo'): ", capabilities("cairo"), "\n", sep = "")
stopifnot(capabilities("cairo"))
