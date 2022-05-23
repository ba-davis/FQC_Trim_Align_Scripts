

library(readxl)

# function to get individual FQC, Trim, STAR txt files from full excel file
# infile: PE FQC_Trim_Align full excel file

get_indiv_qc_tables <- function(infile) {
  # read in excel file
  df <- as.data.frame(read_xlsx(infile))

  # check ncol
  if (ncol(df) != 29) {
    print("Warning...infile does not have the expected 29 columns.")
  }
  
  # clean up colnames
  colnames(df)[7] <- "R1_GC_percent"
  colnames(df)[8] <- "R2_GC_percent"
  colnames(df)[9] <- "R1_dup_percent"
  colnames(df)[10] <- "R2_dup_percent"
  colnames(df)[13] <- "BothSurviving_percent"
  colnames(df)[15] <- "ForwardSurviving_percent"
  colnames(df)[17] <- "ReverseSurviving_percent"
  colnames(df)[19] <- "ReadPairsDropped_percent"
  colnames(df)[20] <- "InputReadPairs"

  # get fqc table
  df1 <- df[ ,c(2,1,3,4,5,6,7,8,9,10)]
  write.table(df1, "fqc_clean_table.txt", sep="\t", col.names=T, row.names=F, quote=F)

  # get trimmomatic table
  df1 <- df[ ,c(2,1,11,12,13,14,15,16,17,18,19)]
  write.table(df1, "trimmomatic_clean_table.txt", sep="\t", col.names=T, row.names=F, quote=F)

  # get star table
  df1 <- df[ ,c(2,1,20,21,22,23,24,25,26,27,28,29)]
  write.table(df1, "star_clean_table.txt", sep="\t", col.names=T, row.names=F, quote=F)
}
