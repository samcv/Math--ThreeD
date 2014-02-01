#!/usr/bin/env perl6

use v6;

use lib $?FILE.path.directory;
use Generator;

Math::ThreeD::Library.new(
    name => 'Mat44',
    constructor => 'mat44',
    elems => my $elems = 16,
    intro => q[sub postcircumfix:<[ ]> (Mat44:D $a, int $i) is export {
    $a.at_pos($i), $a.at_pos($i+4), $a.at_pos($i+8), $a.at_pos($i+12)
}],
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

        op( operator => '-',
            function => 'neg',
            mutator => 'negate',
        ),

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
            expressions => [ (^$elems).map: {"([*] 1..\$a[$_])"} ],
        ),

        op( function => 'dump',
            body => 'say $a.perl',
            return => '',
        ),

    ),
).write('lib/Math/ThreeD/Mat44.pm');

# vim: set expandtab:ts=4:sw=4
