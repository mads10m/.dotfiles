# Generate a pdf version of the document using pdflatex
$pdf_mode = 1;

#$filesep = '/'

$ENV{'SILENT'} //= 1;

$ENV{'PREVIEW_PROGRAM'} //= 'evince';
# Final check if PDF viewer is not defined
# Place dummy value, latexmk will attempt default viewer from OS
$ENV{'PREVIEW_PROGRAM'} //= 'DEFAULT';

# Create file containing a list of the files that these programs have read and written
# For better source file detection
$recorder = 1;

# Use bibtex if an appropriate *.bib file exists
$bibtex_use = 1;

# Define all output directories to be "tmp"
# All build files will now be placed in this directory
$aux_dir = "tmp";
$tmpdir  = "tmp";
$out_dir = 'tmp';

# Add glossary dependency to build glossaries
add_cus_dep('glo', 'gls', 0, 'makeglossaries');

# Add acronym dependency to build glossaries
add_cus_dep('acn', 'acr', 0, 'makeglossaries');

# Subroutine that makes glossaries
sub makeglossaries {
	my ($base_name, $path) = fileparse( $_[0] );
	pushd $path;
	if ( $silent ) {
		my $return = system "makeglossaries -q $base_name";
	} else {
		my $return = system "makeglossaries $base_name";
	};
	popd;
	return $return;
}

# clean up glossary
push @generated_exts, 'glo', 'gls', 'glg';
push @generated_exts, 'acn', 'acr', 'alg';
$clean_ext .= ' %R.ist %R.xdy';
