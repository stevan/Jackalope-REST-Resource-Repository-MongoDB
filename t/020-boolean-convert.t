#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;
use Storable qw[ dclone ];

BEGIN {
    use_ok('Jackalope::REST::Resource::Repository::MongoDB::Util');
}

my $VAR1 = {
          'document' => {
              'general' => {
                             'date_discontinued' => '',
                             'is_assembly' => JSON::XS::false(),
                             'is_hidden' => JSON::XS::true(),
                             'is_generic' => JSON::XS::false(),
                             'description' => {
                                                'en' => 'MINIVAN WITH FLAMES ON IT'
                                              },
                             'long_desc' => {
                                              'en' => ''
                                            },
                             'product_class' => {
                                                  'en' => 'MINIVAN'
                                                },
                             'is_active' => JSON::XS::false(),
                             'notes' => {
                                          'en' => ''
                                        },
                             'short_desc' => {
                                               'en' => ''
                                             },
                             'is_virtual' => JSON::XS::false()
                           },
              'warehouse_info' => {
                                    'division_id' => 'DISNEYWORLD',
                                    'warehouse_id' => 2,
                                    'item_location' => {
                                                         'en' => 'CABLE'
                                                       },
                                    'is_barcoded' => JSON::XS::false(),
                                    'tagged_only' => 0,
                                    'is_stock_managed' => JSON::XS::false()
                                  },
              'cost' => {
                          'default_rate' => 'W',
                          'day_price' => {
                                           'USD' => 25
                                         },
                          'week_price' => {
                                            'USD' => 25
                                          },
                          'maximum_rental_discount' => {
                                                         'USD' => '0'
                                                       }
                        },
              'sales' => {
                           'used' => {
                                       'promote_for_sale' => JSON::XS::false(),
                                       'is_active' => JSON::XS::false(),
                                       'price' => {
                                                    'USD' => 0
                                                  },
                                       'note' => {
                                                   'en' => ''
                                                 }
                                     },
                           'new' => {
                                      'accounting_type' => '',
                                      'reorder_level' => 0,
                                      'reorder_quantity' => 0,
                                      'rental_code_is' => '',
                                      'units_in_stock' => '0',
                                      'case_quantity' => 0,
                                      'unit_price' => {
                                                        'USD' => 0
                                                      }
                                    }
                         },
              'basis_value' => {
                                 'replacement_cost' => {
                                                         'USD' => 296
                                                       },
                                 'replacement_price' => {
                                                          'USD' => 370
                                                        }
                               },
              'manufacturer_info' => {
                                       'country_of_origin' => 'USA',
                                       'brand_name' => {
                                                         'en' => ''
                                                       },
                                       'warranty_length' => 0,
                                       'manufacturer_name' => {
                                                                'en' => 'TOYOTA'
                                                              },
                                       'manufacturer_part' => ''
                                     },
              'size' => {
                          'width' => {
                                       'unit' => 'inch',
                                       'value' => 0
                                     },
                          'is_case' => JSON::XS::false(),
                          'length' => {
                                        'unit' => 'inch',
                                        'value' => '0'
                                      },
                          'weight' => {
                                        'unit' => 'pounds',
                                        'value' => '0'
                                      },
                          'height' => {
                                        'unit' => 'inch',
                                        'value' => '0'
                                      }
                        },
              'misc' => {
                          'basis_code' => '',
                          'auto_include' => 0,
                          'always_check' => JSON::XS::true()
                        },
              'units' => {
                           'in_transit' => 0,
                           'in_repair' => 0,
                           'in_stock' => 0,
                           'augmented_capacity' => 0
                         },
              'code' => {
                          'code' => 'FOOBAR-',
                          'aka' => 'FOOBAR-'
                        }
            }
};

my $converted       = convert_to_booleans( dclone( $VAR1 ) );
my $converted_again = convert_from_booleans( dclone( $converted ) );

is_deeply(
    $converted_again,
    $VAR1,
    '... data structures are the same'
);

is_deeply(
    convert_to_booleans( $converted_again ),
    $converted,
    '... data structures are the same'
);




done_testing;