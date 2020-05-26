load("genbank.RData")

#1
gb <- paste(genbank, collapse = "\n")

accession <- regmatches(gb, regexec("ACCESSION\\s+(\\S{6})", gb))

#2
medline <- regmatches(gb, gregexpr("MEDLINE\\s+\\d+", gb))

#3
sequence <- regmatches(gb, gregexpr("ORIGIN.+$", gb))
sequence <- regmatches(sequence[[1]], gregexpr("\\d+\\K[ctga ]+\n", sequence[[1]], perl = TRUE))
sequence <- paste(unlist(sequence), collapse = "")
sequence <- chartr("atcg","tagc", gsub(" ", "", sequence))
sequence <- gsub("\n", "", sequence)
sequence
