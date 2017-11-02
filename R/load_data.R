.ppm_abs <- function(a,b) (abs(a-b)/mean(c(abs(a), abs(b))))*1E6


.compVector <- function(x, comp_FUN,...){   
    
    # Make check happy
    . <- NULL
    
    mat <- outer(x,x,comp_FUN,...)
    
    mat %<>%
        as_data_frame %>% 
        setNames(paste0("col",1:ncol(.))) %>% 
        mutate(row=1:n()) %>% 
        gather("col", "value", -row) %>% 
        mutate(col=gsub("col","",col)) %>% 
        filter(row>col)
    
    return(mat)
}

.modeClash <- function(a,b, mode, ppm=30) {
    
    if(mode=="pos"){
        res <- (a>0 & b<0 & .ppm_abs(abs(b)+2*1.007276, a)<30) |
               (b>0 & a<0 & .ppm_abs(abs(a)+2*1.007276, b)<30)
    }
    
    if(mode=="neg"){
        res <- (a>0 & b<0 & .ppm_abs(abs(b)-2*1.007276, a)<30) |
               (b>0 & a<0 & .ppm_abs(abs(a)-2*1.007276, b)<30)
    }
    
    
    if(mode=="ei"){
        res <- FALSE
        }
    
    return(res)
}


#' Load adduct/fragment rules for CAMERA
#' 
#' This function loads rules for use with CAMERA adduct annotation.
#'
#' @param mode The ionization mode. Can be "pos", "neg" or "ei".
#' @param warn_clash Warn for adducts/fragments that gives rise to the same m/z difference in spectra.
#' @param clash_ppm ppm to use for the above check.
#'
#' @return tibble defining adduct rules.
#' @export
#'
#' @author Jan Stanstrup, \email{stanstrup@gmail.com}
#'
#' @examples
#' MZ_CAMERA(mode="pos", warn_clash = TRUE, clash_ppm=30)
#' 
#' 
#' @importFrom magrittr %<>% extract2
#' @importFrom dplyr as_data_frame mutate filter rename select %>% n
#' @importFrom tidyr gather
#' @importFrom stats setNames
#' 
MZ_CAMERA <- function(mode, warn_clash = TRUE, clash_ppm){
  
    
    # Make check happy
    value <- mode_clash <- row_name <- col_name <- . <- NULL
    
    
    rules <- switch(mode,
                    neg = .CAMERA_rules_neg,
                    pos = .CAMERA_rules_pos,
                    ei = .CAMERA_rules_ei
                    )
    
    if(!warn_clash) return(rules)

  
  # Check to find adduct/fragment combinations that would give the same difference.
  # This can course bad annotation: for example +NH4 getting annotated instead of -NH3
  # Better to remove the most unlikely or lower the score for the least likely assignment
  same <- rules %>% 
             extract2("massdiff") %>% 
             .compVector(.modeClash, mode=mode, ppm=clash_ppm) %>% 
             rename(mode_clash = value) %>% 
             filter(mode_clash==TRUE)
 
 same %<>% 
     mutate(row_name = as.vector(as.matrix(rules[as.numeric(row),"name"]))) %>% 
     mutate(col_name = as.vector(as.matrix(rules[as.numeric(col),"name"]))) %>% 
     select(first = row_name, second = col_name)
  
 
 if (nrow(same)!=0){
     
     warning(paste("The following adducts/fragments seem to collide.","\n"), immediate. = TRUE)
     print(same)
     cat("\n\nConsider removing one of them. Example:","\n",
         'rules=rules[            !grepl("[M+NH4]+",rules[,"name"],fixed=TRUE)         ,]')
     
 }

  
  return(rules)
}


