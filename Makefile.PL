use ExtUtils::MakeMaker;
WriteMakefile(
  NAME          => 'GD::Graph::Cartesian',
  VERSION_FROM  => 'lib/GD/Graph/Cartesian.pm',
  ABSTRACT_FROM => 'lib/GD/Graph/Cartesian.pm',
  PREREQ_PM     => {
                     'GD'                => 2.02,
                     'List::Util'        => 0,
                     'List::MoreUtils'   => 0,
                   },
             );
