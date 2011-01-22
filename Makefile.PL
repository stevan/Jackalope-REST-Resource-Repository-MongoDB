use strict;
use warnings;
use inc::Module::Install;

name 'Jackalope-REST-Resource-Repository-MongoDB';
all_from 'lib/Jackalope/REST/Resource/Repository/MongoDB.pm';
license 'perl';

requires 'Jackalope'                  => 0;
requires 'MongoDB'                    => 0;
requires 'boolean'                    => 0;
requires 'JSON::XS'                   => 0;
requires 'Data::Visitor::Callback'    => 0;
requires 'Scalar::Util'               => 0;

build_requires 'Test::More'            => 0;
build_requires 'Test::Moose'           => 0;
build_requires 'Test::Fatal'           => 0;

tests('t/*.t');

WriteAll();