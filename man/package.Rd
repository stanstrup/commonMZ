\name{commonMZ}
\docType{package}

\alias{commonMZ-package}
\alias{adducts_fragments}
\alias{contaminants_neg}
\alias{contaminants_pos}
\alias{repeating_units_neg}
\alias{repeating_units_pos}

\title{Collection of common *m/z*}

\author{Jan Stanstrup}

\description{
This is a collection of common *m/z* values found in mass spectrometry.
}
  
\details{
This package contains:
  
\itemize{
          \item{\code{\link[commonMZ]{MZ_CAMERA}}: A function that returns a 
                table of common fragment and adducts for use with CAMERA in 
                positive mode. The listed mass refers to mass differences to the 
                uncharged species.
                }
          \item{\code{adducts_fragments}: A table of common fragment and 
                adducts. The listed mass refers to mass differences.
                }
          \item{\code{contaminants_neg}: A table of common contaminant masses in 
                negative ionization mode.
                }
          \item{\code{contaminants_pos}: A table of common contaminant masses in 
                positive ionization mode.
                }
          \item{\code{repeating_units_neg}: A table of common series of repeated 
                units (mass differences) in negative ionization mode.
                }
          \item{\code{repeating_units_pos}: A table of common series of repeated 
                units (mass differences) in positive ionization mode.
                }
                
        }
  
 


}

\references{
 The data in these tables are primarily from:


\itemize{
          \item{The Supplementary Data from: Keller BO, Sui J, Young AB, 
                Whittal RM. \href{https://doi.org/10.1016/j.aca.2008.04.043}{
                Interferences and contaminants encountered in modern mass 
                spectrometry.} Anal Chim Acta. 2008;627(1):71-81.
              }
        }

}

\keyword{package}
\keyword{data}
