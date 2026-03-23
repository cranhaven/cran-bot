#!/usr/bin/Rscript

# Read local mirror and notifications
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

pkgs2repo <- function(pkgs) {
    s <- strsplit(x = pkgs$URL, split = ",|[[:space:]]")
    urls_pkgs <- Map(c, pkgs$BugReports, s)
    names(urls_pkgs) <- pkgs$Package
    url_repo <- urls2ur(urls_pkgs)
    bug_repo <- urls2ur(pkgs$BugReports)
    ur <- lengths(url_repo)
    br <- lengths(bug_repo)
    
    # Pick the bug repo url or from the url repo if needed
    out <- vector("list", length = length(url_repo))
    for (i in seq_along(url_repo)) {
        if (br[[i]] == 2L) {
            out[[i]] <- bug_repo[[i]][1, , drop = TRUE]
        } else if (br[[i]] <= 1L && ur[[i]] > 1L) {
            dist <- adist(url_repo[[i]][, 2], names(urls_pkgs)[i], ignore.case = TRUE, fixed = TRUE)[, 1]
            dist <- dist[!is.na(dist)]
            # At most 2 changes from the package name
            if (!anyNA(dist) && any(dist <= 2)) {
                # Select first that meet requirements
                out[[i]] <- url_repo[[i]][dist <= 2][1:2]
            }
        }
    }
    names(out) <- names(urls_pkgs)
    out
}


p2r <- pkgs2repo(pkgs)

url_github <- grep("github.com", pkgs$URL, fixed = TRUE)
s <- strsplit(x = pkgs$URL, split = ",?[[:space:]]")
github <- grep("github.com", pkgs$BugReports, fixed = TRUE)
m <- match(issues$Package, pkgs$Package)

affected_packages <- p2r[m]
affected_packages_w_repo <- affected_packages[lengths(affected_packages) > 1]

apwr <- sapply(affected_packages_w_repo, paste0, collapse = "/")
fake <- rep("cranhaven/cran-bot-scratch", length = 1) # length(apwr))
endpoint <- paste0("POST /repos/", fake, "/issues")
library("gh")
# Keep in mind CRAN survey's results at: https://github.com/r-devel/cran-cookbook/wiki/CRAN-Cookbook-Survey-Results
body <- "Dear maintainers and collaborators,

This is an automated issue sent by some [volunteers that help with CRAN](https://cran.r-project.org/CRAN_team.htm) and package maintainers .
Automatic checks performed on CRAN identified some issues and volunteers are concerned that to maintain the package on CRAN some changes are required. 
The maintainer should have received an email on %s, but it might have went to the spam folder or not reached the inbox.
We hope that this issue helps in that case, if you received the email it might provide additional information that we hope it will help.

The issues detected can be explored on [CRAN checks results](%s)
Some common problems and solutions are posted on [The CRAN Cookbook](https://contributor.r-project.org/cran-cookbook/). 
You might find your solution there.
You can also check the [r-pkg-devel mailing list](https://stat.ethz.ch/mailman/listinfo/r-package-devel) for previous problems and solutions or ask for assistance to the community.

Reply to the email address if you require CRAN's maintainers assitance (keep in mind sending it as text only and give some days to get back to you)
"
url_checks <- sprintf("https://cran.r-project.org/web/checks/check_results_%s.html", names(affected_packages_w_repo))
date <- "2026-03-23"
body <- sprintf(body, date, url_checks)
pos_issues <-  match(names(affected_packages_w_repo), issues$Package)
title <- sprintf("Changes required to maintain the package up to CRAN standards, id %s", 42) #issues$id[pos_issues])

response <- gh(endpoint = endpoint,
    body = body[1],
    title = title, 
    .accept = "application/vnd.github+json",
    .send_headers = c("X-GitHub-Api-Version" = "2022-11-28"))

if (!is.null(response$url)) {
    message("Success posting")
}
# If issue locked
# If reply to an existing issue
# If private/not accepted

    # Handle response

# Packages with no BugReports on github open on this repository

