use v6;
use Panda::Builder;

class Build is Panda::Builder {
    method build ($where) {
		require "{$where.path.absolute.child('gen-libs.p6')}";
    }
}

