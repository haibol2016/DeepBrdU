library("rhdf5")

args <- commandArgs(trailingOnly=TRUE)
h5files <- dir(args[1], ".fast5", full.names = TRUE)

CON_complement <- file(args[2], "a")
CON_template <- file(args[3], "a")

for (f in h5files) {
    h5f <- H5Fopen(f)

    a <- h5f$`Analyses/Basecall_1D_000/BaseCalled_complement/Fastq`
    a <- gsub("\\s+I","_I",  a)
    writeLines(a, con = CON_complement, sep = "", useBytes = FALSE)
    
    b <- h5f$`Analyses/Basecall_1D_000/BaseCalled_template/Fastq`
    b <- gsub("\\s+I","_I",  b)
    writeLines(b, con = CON_template, sep = "", useBytes = FALSE)
    
    h5closeAll()
}

close(CON_complement)
close(CON_template)
