
# cran-bot

<!-- badges: start -->
<!-- badges: end -->

The goal of cran-bot is to provide the scripts required to notify packages maintainers on their own repository when CRAN requires changes on the package.

bot.R is the script to notify maintainers on the github repositories.
.Renviron should exists on this folder with two variables pointing to the local file with CRAN information about issues.

In addition a cron job should setup to:
 1. Update the local CRAN mirror of issues
 2. Run the bot.R file to notify users

If the BugReports doesn't point to github but the URL does it will try to use the URL to infer the repository to which open the issue. 

The bot will open issues on this repository if the BugReports or URL pointing to github:
 - the repo is private
 - is malformed (missing repo)
 - Any other issue


Contents of the message: 
 - State who is writing.
 - State why we are opening a new issue: Point to the error on CRAN (and mention the email sent).
 - Give pointers about how to find help (CRAN cookbook, mailing list, ...)
 - If possible give pointers about how to fix issues

