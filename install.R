# Create vector of package names to install
packages <- c(
  "DBI", "MASS", "Matrix", "R6", "RColorBrewer", "Rcpp", "askpass", "base64enc",
  "bigrquery", "bit", "bit64", "brio", "bslib", "cachem", "cli", "clipr",
  "clock", "colorspace", "cpp11", "crayon", "crosstalk", "curl", "data.table",
  "digest", "dplyr", "evaluate", "fansi", "farver", "fastmap", "fontawesome",
  "fs", "gargle", "generics", "ggplot2", "glue", "gt", "gtable", "highr", "hms",
  "htmltools", "htmlwidgets", "httr", "isoband", "jquerylib", "jsonlite",
  "knitr", "labeling", "later", "lattice", "lazyeval", "lifecycle", "magrittr",
  "memoise", "mgcv", "mime", "munsell", "nlme", "openssl", "pillar", "pkgconfig",
  "plotly", "prettyunits", "progress", "promises", "purrr", "rapidjsonr",
  "rappdirs", "readr", "renv", "rlang", "rmarkdown", "sass", "scales", "stringi",
  "stringr", "sys", "tibble", "tidyr", "tidyselect", "tinytex", "tzdb", "utf8",
  "vctrs", "viridisLite", "vroom", "withr", "xfun", "yaml"
)

# Install packages
install.packages(packages)
