use v6;
use Math::ThreeD::Vec;
use Test;

multi sub length(Vec3 $v) {
    ($v[0] ** 2 + $v[1] ** 2 + $v[2] ** 2).sqrt;
}

multi sub is-approx(Vec3 $v1, Vec3 $v2, $desc?) {
    if length(Vec3.new($v2[0] - $v1[0], $v2[1] - $v1[1], $v2[2] - $v1[2])) < 1e-6 {
        ok True, $desc;
    } else {
        ok False, $desc;
        say "    Expected: { $v2.perl }";    
        say "         Got: { $v1.perl }";    
    }
}

isa_ok Vec3.new(1.0, 0.0, 0.0), Vec3, "Can make a Vec3 with new";
ok (length(Vec3.new(1.0, 2.0, 3.0)) - 14.sqrt) < 1e-10, "length works";
ok (length(Vec3.new(5.0, 4.0, 2.0)) - 45.sqrt) < 1e-10, "length works";
is-approx Vec3.new(1.0, 0.0, 0.0), Vec3.new(1.0, 0.0, 0.0), "is-approx works";
is-approx Vec3.new(1.0, 2.0, 4.0), Vec3.new(1.0, 2.0, 4.0), "is-approx works";

done;