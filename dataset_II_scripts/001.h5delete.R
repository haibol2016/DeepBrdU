#!/usr/bin/env Rscript
library(rhdf5)

args = commandArgs(trailingOnly=TRUE)
print(args[1])

null <- lapply(args, function(.arg){
    h5file <- .arg
    groups <- h5ls(file = h5file, recursive = FALSE)$name
    keep <- c("Raw","UniqueGlobalKey")
    # Delete the groups
    remove_groups <- groups[!groups %in% keep ]

    print(remove_groups)
    if (length(remove_groups) >= 1) {
    for (i in remove_groups) {
        h5delete(h5file, i)
    }
  }
})
