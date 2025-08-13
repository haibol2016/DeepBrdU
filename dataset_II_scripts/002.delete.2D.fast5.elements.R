#!/usr/bin/env Rscript
library("rhdf5")
library("future")
library("future.apply")

plan("multicore")

args = commandArgs(trailingOnly=TRUE)

files <- dir(args[1], ".fast5$", full.names =TRUE)

delete_items <- function(h5file){
    group_name <- h5ls(h5file, recursive = TRUE)[, 1:2]

    group_name <- ifelse(grepl("/$", group_name[,1]),
                         paste0(group_name[,1], group_name[,2]),
                         paste(group_name[,1], group_name[,2], sep = "/"))
    keep_group_name <- c("/Analyses",
                         "/Analyses/Basecall_1D_000",
                         "/Analyses/Basecall_1D_000/BaseCalled_complement",
                         "/Analyses/Basecall_1D_000/BaseCalled_complement/Fastq",
                         "/Analyses/Basecall_1D_000/BaseCalled_template",
                         "/Analyses/Basecall_1D_000/BaseCalled_template/Fastq"
    )
    keep_pattern_raw <- group_name[grepl("^/Raw", group_name)]
    keep_pattern_key <- group_name[grepl("^/UniqueGlobalKey", group_name)]

    keep_group_names <- c(keep_group_name, keep_pattern_raw, keep_pattern_key)

    remove_names <- group_name[!group_name%in%keep_group_names]

    if (length(remove_names) >0){
        for (i in remove_names) {
            try({h5delete(h5file, name = i)})
        }
    }
}

null <- future_lapply(files, delete_items)
