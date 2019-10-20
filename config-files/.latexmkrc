# Generate a pdf version of the document using pdflatex
$pdf_mode = 1;

#$filesep = '/'

$ENV{'PREVIEW_PROGRAM'} //= 'evince';
# Final check if PDF viewer is not defined
# Place dummy value, latexmk will attempt default viewer from OS
$ENV{'PREVIEW_PROGRAM'} //= 'DEFAULT';

# Create file containing a list of the files that these programs have read and written
# For better source file detection
$recorder   = 1;

# Use bibtex if an appropriate *.bib file exists
$bibtex_use = 1;

# Define all output directories to be "tmp"
# All build files will now be placed in this directory
$aux_dir = "tmp";
$tmpdir  = "tmp";
$out_dir = 'tmp';

