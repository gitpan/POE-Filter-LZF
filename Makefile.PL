use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
# Blah!

WriteMakefile(
			  'NAME'	=> 'POE::Filter::LZF',
			  'PREREQ_PM' => {
							  'POE'    => 0.3501,
							  'Compress::LZF' => 1.51,
							  'Carp' => 0,
							 },
			  'VERSION_FROM' => 'lib/POE/Filter/LZF.pm', # finds $VERSION
			  'dist' => { 'COMPRESS' => 'gzip --best' },
			 );
