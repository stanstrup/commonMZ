x2loc <- function(x) ifelse(grepl("X", x),TRUE,FALSE)


## Load any db objects whenever the package is loaded.
.onLoad <- function(libname, pkgname)
{
    options(useFancyQuotes=FALSE)
    ns <- asNamespace(pkgname)

    
    
    # adducts_fragments
    adducts_fragments <- 
        readr::read_tsv(system.file("extdata/adducts_fragments.tsv", package=pkgname, lib.loc=libname),
                        col_names=TRUE,
                        col_types = readr::cols(mz_diff = readr::col_double(), 
                                                origin = readr::col_character(), 
                                                reference = readr::col_character()
                                               )
                       )

     assign("adducts_fragments", adducts_fragments, envir=ns)
     namespaceExport(ns, "adducts_fragments")
    
    
    # .contaminants_neg
    contaminants_neg <- 
        readr::read_tsv(system.file("extdata/contaminants_-.tsv", package=pkgname, lib.loc=libname),
                        col_names=TRUE,
                        col_types = readr::cols(ion_ID = readr::col_integer(),
                                                mz = readr::col_double(),
                                                ion_type = readr::col_character(),
                                                molecular_formula = readr::col_character(),
                                                compound_ID = readr::col_character(),
                                                origin = readr::col_character(),
                                                references = readr::col_character()
                                               )
                       )

    assign("contaminants_neg", contaminants_neg, envir=ns)
    namespaceExport(ns, "contaminants_neg")
    
    # .contaminants_pos
    contaminants_pos <- 
        readr::read_tsv(system.file("extdata/contaminants_+.tsv", package=pkgname, lib.loc=libname),
                        col_names=TRUE,
                        col_types = readr::cols(ion_ID = readr::col_integer(),
                                                mz = readr::col_double(),
                                                ion_type = readr::col_character(),
                                                molecular_formula = readr::col_character(),
                                                compound_ID = readr::col_character(),
                                                origin = readr::col_character(),
                                                ESI = readr::col_character(),
                                                MALDI = readr::col_character(),
                                                references = readr::col_character()
                                               )
                       )  
        
    contaminants_pos$ESI <- x2loc(contaminants_pos$ESI)
    contaminants_pos$MALDI <- x2loc(contaminants_pos$MALDI)
    

    assign("contaminants_pos", contaminants_neg, envir=ns)
    namespaceExport(ns, "contaminants_pos")
    
    # .repeating_units_neg
    repeating_units_neg <- 
        readr::read_tsv(system.file("extdata/repeating_units_-.tsv", package=pkgname, lib.loc=libname),
                        col_names=TRUE,
                        col_types = readr::cols(mz_diff = readr::col_double(),
                                                origin = readr::col_character(),
                                                reference = readr::col_character()
                                               )
                        
                       )  
        

    assign("repeating_units_neg", contaminants_neg, envir=ns)
    namespaceExport(ns, "repeating_units_neg")
    
    # .repeating_units_pos
    repeating_units_pos <- 
        readr::read_tsv(system.file("extdata/repeating_units_+.tsv", package=pkgname, lib.loc=libname),
                        col_names=TRUE,
                        col_types = readr::cols(mz_diff = readr::col_double(),
                                                origin = readr::col_character(),
                                                reference = readr::col_character()
                                               )
                        
                       )  
        

    assign("repeating_units_pos", contaminants_neg, envir=ns)
    namespaceExport(ns, "repeating_units_pos")
    
    #.CAMERA_rules_pos
    .CAMERA_rules_pos <- 
        readxl::read_xlsx(system.file("extdata/CAMERA_rules_pos.xlsx", package=pkgname, lib.loc=libname),
                        col_names=TRUE
                       )  
        
    .CAMERA_rules_pos$oidscore <- as.integer(.CAMERA_rules_pos$oidscore)
    .CAMERA_rules_pos$quasi <- as.integer(.CAMERA_rules_pos$quasi)
    .CAMERA_rules_pos$nmol <- as.integer(.CAMERA_rules_pos$nmol)
    .CAMERA_rules_pos$charge <- as.integer(.CAMERA_rules_pos$charge)
     
    assign(".CAMERA_rules_pos", .CAMERA_rules_pos, envir=ns)
    
    
    # .CAMERA_rules_neg
    .CAMERA_rules_neg <- 
        readxl::read_xlsx(system.file("extdata/CAMERA_rules_neg.xlsx", package=pkgname, lib.loc=libname),
                        col_names=TRUE
                       )  
        
    .CAMERA_rules_neg$oidscore <- as.integer(.CAMERA_rules_neg$oidscore)
    .CAMERA_rules_neg$quasi <- as.integer(.CAMERA_rules_neg$quasi)
    .CAMERA_rules_neg$nmol <- as.integer(.CAMERA_rules_neg$nmol)
    .CAMERA_rules_neg$charge <- as.integer(.CAMERA_rules_neg$charge)
     
    assign(".CAMERA_rules_neg", .CAMERA_rules_neg, envir=ns)

    
    # .CAMERA_rules_neg
    .CAMERA_rules_ei <- 
        readxl::read_xlsx(system.file("extdata/CAMERA_rules_EI.xlsx", package=pkgname, lib.loc=libname),
                        col_names=TRUE
                       )  
        
    .CAMERA_rules_ei$oidscore <- as.integer(.CAMERA_rules_ei$oidscore)
    .CAMERA_rules_ei$quasi <- as.integer(.CAMERA_rules_ei$quasi)
    .CAMERA_rules_ei$nmol <- as.integer(.CAMERA_rules_ei$nmol)
    .CAMERA_rules_ei$charge <- as.integer(.CAMERA_rules_ei$charge)
     
    assign(".CAMERA_rules_ei", .CAMERA_rules_ei, envir=ns)
}

