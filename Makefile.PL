use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
	'NAME'		=> 'Audio::Audiere',
	'VERSION_FROM'	=> 'lib/Audio/Audiere.pm',
	'PREREQ_PM'	=> {
			},
	($] >= 5.005 ?
		(ABSTRACT_FROM  => 'lib/Audio/Audiere.pm',
                AUTHOR         => 'Tels <http://bloodgate.com/>') : ()),
	'CC'		=> 'g++',
	'LD'		=> 'g++',
	'LIBS'		=> [ '-laudiere' ],

#	'LDFLAGS'	=> '-static -L/usr/X11R6/lib -L/usr/local/lib/Irrlicht -lIrrlicht -lXxf86vm -lGL -lGLU -lX11 -lXext -ljpeg -lz',

	'OPTIMIZE'	=> '-O2',
	'DEFINE'	=> '', # e.g., '-DHAVE_SOMETHING'
	'INC'		=> '',
# makes no difference
	'XSOPT'		=> '-C++', 
#	'OBJECT'	=> '', 
);
