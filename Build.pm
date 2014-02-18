use v6;
use Panda::Builder;

class Build is Panda::Builder {
    method build ($where) {
        require "{$?FILE.path.absolute.parent.child('gen-libs.p6')}";
    }
}

# vim: set ft=perl6:expandtab:ts=4:sw=4
