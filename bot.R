# Read local mirror and 
# R_CRAN_PACKAGE_ACTIONS_URL
# R_CRAN_PACKAGE_ISSUES_URL
environ_file <- ".Renviron"
if (file.exists(environ_file)) {
    readRenviron(environ_file)
}
issues <- tools:::CRAN_package_issues(FALSE)

notifications_file <- "notifications.csv"
if (file.exists(notifications_file)) {
    notifications_sent <- read.csv(notifications_file)
} else {
    notifications_sent <- list2DF(list("ID", "Package", "Date"))
    colnames(notifications_sent) <- notifications_sent
    notifications_sent <- notifications_sent[-1, ]
}

# New issues to message
new_issues <- setdiff(issues$ID, notifications_sent$ID)
notifications <- cbind(issues[issues$ID %in% new_issues, c("ID", "Package")], Date = Sys.Date())
# Open issue
# Keep id of the issue on notifications

write.csv(rbind(notifications_sent, notifications), "notifications.csv", row.names = FALSE)

# Old issues to close
close_issues <- issues$ID[issues$ID == notifications_sent$ID & issues$Before < Sys.Date() +1]
issues <- notifications$Issue[match(notifications$ID, close_issues)]
# Retrieve 


# Retrieve repo
pkgs <- tools::CRAN_package_db()
urls2ur <- function(url) {
    urls_pkgs_github <- lapply(url, function(x) {
        urls <- grep("github.com", x, fixed = TRUE, value = TRUE)
        if (!length(urls)) {
            return(NA)
        }
        urls <- gsub("(.+)(#.+)", "\\1", urls)
        url_split <- strsplit(urls, split = "/", fixed = TRUE)
        ur <- lapply(url_split, function(x) {
            x[4:5]
        })
        do.call(rbind, unique(ur))
    })
}
clean_repo <- function(repos) {
    for (p in pkgs) {

    }
}
pkgs2repo <- function(pkgs) {
    s <- strsplit(x = pkgs$URL, split = ",|[[:space:]]")
    urls_pkgs <- Map(c, pkgs$BugReports, s)
    names(urls_pkgs) <- pkgs$Package
    url_repo <- urls2ur(urls_pkgs)
    bug_repo <- urls2ur(pkgs$BugReports)
    ur <- sapply(url_repo, length)
    br <- sapply(bug_repo, length)
    #TODO pick from bug_repo or if not present from url_repo 
    # (double check that the url_repo somewhat matches the package)
}
url_github <- grep("github.com", pkgs$URL, fixed = TRUE)
s <- strsplit(x = pkgs$URL, split = ",?[[:space:]]")
github <- grep("github.com", pkgs$BugReports, fixed = TRUE)
m <- match(issues$Package, pkgs$Package)
github_w_issues <- intersect(m, github)


# Packages that don't point to a repo
if (anyNA(df_ur$repo)) {
    w <- which(is.na(df_ur$repo))
    package_wo_repo <- pkgs$Package[github_w_issues][w]
}

endpoint <- paste0("POST /repos/", apply(df_ur, 1, paste0, collapse = "/"), "/issues")
library("gh")
response <- gh(endpoint = endpoint, 
    body = list()
    .accept = "application/vnd.github+json", 
    .send_headers = c("X-GitHub-Api-Version" = "2022-11-28"))
    
    # Handle response
    
    # Packages with no BugReports on github open on this repository
    
    