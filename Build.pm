use v6;
use Panda::Builder;

class Build is Panda::Builder {
    method build ($where) {
        require "{$where.path.absolute.child('gen-libs.p6')}";
    }
}

# vim: set expandtab:ts=4:sw=4
