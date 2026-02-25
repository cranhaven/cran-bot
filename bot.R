# Read local mirror and 
# R_CRAN_PACKAGE_ACTIONS_URL
# R_CRAN_PACKAGE_ISSUES_URL
readRenviron(".Renviron")

issues <- tools:::CRAN_package_issues(FALSE)
library("gh")
# New issues to message
# Old issues to close



