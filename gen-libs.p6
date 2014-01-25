#!/usr/bin/env perl6

use v6;
use Shell::Command;

sub generate-vec-ops(@ops) {
    my $methods = '';
    my $subs    = '';
    for @ops -> $spec {
        my ($op, $function, $mutator) = @$spec;
        $methods ~= q:to/CODE/;
            
            # Multi methods for \qq{$op/$function/$mutator} operations
            
            multi method \qq{$function}(Vec3:D $a: Vec3:D $b --> Vec3:D) is pure {
                Vec3.new($a[0] \qq{$op} $b[0],
                         $a[1] \qq{$op} $b[1],
                         $a[2] \qq{$op} $b[2]);
            }

            multi method \qq{$function}(Vec3:D $a: Vec3:D $b, Vec3:D $r --> Vec3:D) {
                $r[0] = $a[0] \qq{$op} $b[0];
                $r[1] = $a[1] \qq{$op} $b[1];
                $r[2] = $a[2] \qq{$op} $b[2];
                $r;
            }
            
            multi method \qq{$mutator}(Vec3:D $a: Vec3:D $b --> Vec3:D) {
                $a[0] \qq{$op}= $b[0];
                $a[1] \qq{$op}= $b[1];
                $a[2] \qq{$op}= $b[2];
                $a;
            }
            
            multi method \qq{$function}(Vec3:D $a: Numeric:D $b --> Vec3:D) is pure {
                Vec3.new($a[0] \qq{$op} $b,
                         $a[1] \qq{$op} $b,
                         $a[2] \qq{$op} $b);
            }

            multi method \qq{$function}(Vec3:D $a: Numeric:D $b, Vec3:D $r --> Vec3:D) {
                $r[0] = $a[0] \qq{$op} $b;
                $r[1] = $a[1] \qq{$op} $b;
                $r[2] = $a[2] \qq{$op} $b;
                $r;
            }
            
            multi method \qq{$mutator}(Vec3:D $a: Numeric:D $b --> Vec3:D) {
                $a[0] \qq{$op}= $b;
                $a[1] \qq{$op}= $b;
                $a[2] \qq{$op}= $b;
                $a;
            }
            
            CODE
        $subs ~= q:to/CODE/;
            
            
            # Multi subs for \qq{$op/$function} operations
            
            proto \qq{$function}(|) is export {*}

            multi sub \qq{$function}(Vec3:D $a, Vec3:D $b --> Vec3:D) is pure {
                Vec3.new($a[0] \qq{$op} $b[0],
                         $a[1] \qq{$op} $b[1],
                         $a[2] \qq{$op} $b[2]);
            }

            multi sub \qq{$function}(Vec3:D $a, Vec3:D $b, Vec3:D $r --> Vec3:D) {
                $r[0] = $a[0] \qq{$op} $b[0];
                $r[1] = $a[1] \qq{$op} $b[1];
                $r[2] = $a[2] \qq{$op} $b[2];
                $r;
            }
            
            multi sub infix:<\qq{$op}>(Vec3:D $a, Vec3:D $b --> Vec3:D) is pure is export {
                Vec3.new($a[0] \qq{$op} $b[0],
                         $a[1] \qq{$op} $b[1],
                         $a[2] \qq{$op} $b[2]);
            }

            multi sub infix:<\qq{$op}=>(Vec3:D $a, Vec3:D $b --> Vec3:D) is export {
                $a[0] \qq{$op}= $b[0];
                $a[1] \qq{$op}= $b[1];
                $a[2] \qq{$op}= $b[2];
                $a;
            }

            multi sub \qq{$function}(Vec3:D $a, Numeric:D $b --> Vec3:D) is pure {
                Vec3.new($a[0] \qq{$op} $b,
                         $a[1] \qq{$op} $b,
                         $a[2] \qq{$op} $b);
            }

            multi sub \qq{$function}(Vec3:D $a, Numeric:D $b, Vec3:D $r --> Vec3:D) {
                $r[0] = $a[0] \qq{$op} $b;
                $r[1] = $a[1] \qq{$op} $b;
                $r[2] = $a[2] \qq{$op} $b;
                $r;
            }
            
            multi sub infix:<\qq{$op}>(Vec3:D $a, Numeric:D $b --> Vec3:D) is pure is export {
                Vec3.new($a[0] \qq{$op} $b,
                         $a[1] \qq{$op} $b,
                         $a[2] \qq{$op} $b);
            }

            multi sub infix:<\qq{$op}=>(Vec3:D $a, Numeric:D $b --> Vec3:D) is export {
                $a[0] \qq{$op}= $b;
                $a[1] \qq{$op}= $b;
                $a[2] \qq{$op}= $b;
                $a;
            }

            multi sub \qq{$function}(Numeric:D $a, Vec3:D $b --> Vec3:D) is pure {
                Vec3.new($a \qq{$op} $b[0],
                         $a \qq{$op} $b[1],
                         $a \qq{$op} $b[2]);
            }

            multi sub \qq{$function}(Numeric:D $a, Vec3:D $b, Vec3:D $r --> Vec3:D) {
                $r[0] = $a \qq{$op} $b[0];
                $r[1] = $a \qq{$op} $b[1];
                $r[2] = $a \qq{$op} $b[2];
                $r;
            }
            
            multi sub infix:<\qq{$op}>(Numeric:D $a, Vec3:D $b --> Vec3:D) is pure is export {
                Vec3.new($a \qq{$op} $b[0],
                         $a \qq{$op} $b[1],
                         $a \qq{$op} $b[2]);
            }
            CODE
    }

    $methods ~= q:to/CODE/;
        
        # Multi methods for unary -/neg/negate operations
        
        multi method neg(Vec3:D $a: --> Vec3:D) is pure {
            Vec3.new(-$a[0], -$a[1], -$a[2]);
        }
        
        multi method neg(Vec3:D $a: Vec3:D $r --> Vec3:D) {
            $r[0] = -$a[0];
            $r[1] = -$a[1];
            $r[2] = -$a[2];
            $r;
        }

        multi method negate(Vec3:D $a --> Vec3:D) {
            $a[0] = -$a[0];
            $a[1] = -$a[1];
            $a[2] = -$a[2];
            $a;
        }
        
        
        # Multi methods for other operations
        
        multi method dot(Vec3:D $a: Vec3:D $b --> Numeric:D) is pure {
            $a[0] * $b[0] + $a[1] * $b[1] + $a[2] * $b[2];
        }
        
        CODE

    $subs ~= q:to/CODE/;
        

        # Multi subs for unary -/neg/negate operations
        
        proto neg(|) is export {*}
        
        multi sub neg(Vec3:D $a --> Vec3:D) is pure {
            Vec3.new(-$a[0], -$a[1], -$a[2]);
        }
        
        multi sub neg(Vec3:D $a, Vec3:D $r --> Vec3:D) {
            $r[0] = -$a[0];
            $r[1] = -$a[1];
            $r[2] = -$a[2];
            $r;
        }

        proto negate(|) is export {*}        
        multi sub negate(Vec3:D $a --> Vec3:D) {
            $a[0] = -$a[0];
            $a[1] = -$a[1];
            $a[2] = -$a[2];
            $a;
        }

        multi sub prefix:<->(Vec3:D $a --> Vec3:D) is pure {
            Vec3.new(-$a[0], -$a[1], -$a[2]);
        }
        
        
        # Multi subs for other operations

        proto dot(|) is export {*}
        
        multi sub dot(Vec3:D $a, Vec3:D $b --> Numeric:D) is pure {
            $a[0] * $b[0] + $a[1] * $b[1] + $a[2] * $b[2];
        }
        
        proto infix:<<"\x22c5">>(|) is export {*}
        
        multi sub infix:<<"\x22c5">>(Vec3:D $a, Vec3:D $b --> Numeric:D) is pure {
            $a[0] * $b[0] + $a[1] * $b[1] + $a[2] * $b[2];
        }
        CODE

    my $code = qq:to/CODE/;
        # DO NOT EDIT!  This code is generated by $*PROGRAM_NAME!
        
        class Vec3 is Array \{
        $methods.indent(4)}
        $subs
        CODE
    
    return $code;
}

sub write-vec-pm($outfile, @ops) {
    mkpath($outfile.path.parent);
    my $out = $outfile.path.open(:w);
    $out.print: generate-vec-ops(@ops);
    $out.close;
}

sub MAIN() {
    my @vec-ops = (
       #  - neg negate
       [< + add plus    >],
       [< - sub minus   >],
       [< * mul times   >],
       [< / div divide  >],
       [< % mod modulus >],
    );
    write-vec-pm('lib/Math/ThreeD/Vec.pm', @vec-ops);
}
