# Text-mining

x <- c("abc","bcd","cde","def")

# grep
grep("bc", x, value = T)
grep("bc", x, invert = T)
grep("BC", x, ignore.case = T)
grepl("bc", x) # bool

# string substitution
sub(".*(bc).*", "gh", x)

# character translation
x <- "This lecture is poor"
chartr("pr", "gd", x)

# regular expression searching
a <- "Mississippi contains a palindrome ississi"
regexpr("iss", a)
regexec(".(ss)", a)
b <- gregexpr("iss", a)

# regular expression matching
regmatches(a, b)


load("genbank.RData")
gb <- paste(genbank, collapse = "\n")

accession <- regmatches(gb, regexec("ACCESSION\\s+(\\S{6})", gb))
medline <- regmatches(gb, gregexpr("MEDLINE\\s+\\d+", gb))
