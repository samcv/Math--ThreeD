#!/usr/bin/env perl6

use v6;

use lib $?FILE.path.directory;
use Generator;

Math::ThreeD::Library.new(
    name => 'Vec3',
    constructor => 'vec3',
    elems => 3,
    ops => (

        op( operator => '+',
            function => 'add',
            mutator => 'plus',
            args => [[ <obj> ],[ <num> ]],

        ),

        op( operator => '-',
            function => 'sub',
            mutator => 'minus',
            args => [[ <obj> ],[ <num> ]],
        ),

        op( operator => '-',),

        op( operator => '*',
            function => 'mul',
            mutator => 'times',
            args => [[ <obj> ],[ <num> ]],
        ),

        op( operator => '/',
            function => 'div',
            mutator => 'divide',
            args => [[ <obj> ],[ <num> ]],
        ),

        op( operator => '%',
            function => 'mod',
            mutator => 'modulus',
            args => [[ <obj> ],[ <num> ]],
        ),

        op( operator => '!',
            postfix => True,
            # not correct or optimal; just testing postfix
            expressions => ['([*] 1..$a[0])', '([*] 1..$a[1])', '([*] 1..$a[2])'],
        ),

        op( operator => '⨯',
            function => 'cross',
            mutator => 'cross-with',
            args => [ ['obj'] ],
            expressions => [
                '$a[1] * $b[2] - $a[2] * $b[1]',
                '$a[2] * $b[0] - $a[0] * $b[2]',
                '$a[0] * $b[1] - $a[1] * $b[0]'
            ],
        ),

        op( operator => '⋅',
            function => 'dot',
            args => [ ['obj'] ],
            return => 'num',
            expression => '$a[0]*$b[0] + $a[1]*$b[1] + $a[2]*$b[2]',
        ),

        op( function => 'length_sqr',
            return => 'num',
            expression => '$a[0]*$a[0] + $a[1]*$a[1] + $a[2]*$a[2]',
        ),

        op( function => 'length',
            return => 'num',
            expression => 'sqrt( $a[0]*$a[0] + $a[1]*$a[1] + $a[2]*$a[2] )',
        ),

        op( function => 'rot-x',
            mutator => 'rotate-x',
            args => [ ['num'] ],
            intro => 'my ($sin, $cos) = sin($b), cos($b);',
            expressions => [
                '$a[0]',
                '$a[1] * $cos - $a[2] * $sin',
                '$a[1] * $sin + $a[2] * $cos',
            ],
        ),

        op( function => 'rot-y',
            mutator => 'rotate-y',
            args => [ ['num'] ],
            intro => 'my ($sin, $cos) = sin($b), cos($b);',
            expressions => [
                '$a[0] * $cos - $a[2] * $sin',
                '$a[1]',
                '$a[0] * $sin + $a[2] * $cos',
            ],
        ),

        op( function => 'rot-z',
            mutator => 'rotate-z',
            args => [ ['num'] ],
            intro => 'my ($sin, $cos) = sin($b), cos($b);',
            expressions => [
                '$a[0] * $cos - $a[1] * $sin',
                '$a[0] * $sin + $a[1] * $cos',
                '$a[2]',
            ],
        ),

        op( function => 'dump',
            body => 'say $a.perl',
            return => '',
        ),

    ),
).write('lib/Math/ThreeD/Vec3.pm');

# vim: set expandtab:ts=4:sw=4
