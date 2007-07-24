use ExtUtils::MakeMaker;
WriteMakefile(
  NAME      => q{GD::Graph::Cartesian},
  VERSION_FROM => q{lib/GD/Graph/Cartesian.pm},
  PREREQ_PM => {
                 strict            => 0,
                 vars              => 0,
                 GD                => 0,
                #Graphics::ColorNames => 0, #no longer required but nice to have
               },
               ($] >= 5.005 ? 
                 (
                   ABSTRACT_FROM => 'lib/GD/Graph/Cartesian.pm',
                 ) : ()
               )
             );
