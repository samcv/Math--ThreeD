# TODO
# expand param and return type definitions
# think about matrix ops

use v6;
use Shell::Command;

class Math::ThreeD::Operation {
    has Str $.function;
    has Str $.mutator;
    has Str $.operator;
    has Bool $.postfix = False;

    has Positional @.args = []; # Str:D where any <num obj>
    has $.return = 'obj';

    has Str $.intro;
    has Str $.body;
    has Stringy $.expression;
    has @.expressions;

    method build (:$lib!) {
        my $return = '';
        
        for @.args {
            if self.function {
                $return ~= self.build_routine('sub', 'new', $_, :$lib);
                $return ~= self.build_routine('method', 'new', $_, :$lib);
                unless self.body { # TODO?
                    $return ~= self.build_routine('sub', 'rw', $_, :$lib);
                    $return ~= self.build_routine('method', 'rw', $_, :$lib);
                }
            }
            if self.mutator {
                $return ~= self.build_routine('sub', 'mutator', $_, :$lib);
                $return ~= self.build_routine('method', 'mutator', $_, :$lib);
            }
            if self.operator {
                $return ~= self.build_routine('operator', 'new', $_, :$lib);
                if @$_ == 1 && $_[0] eq 'num' {
                    $return ~= self.build_routine('operator', 'new', $_,
                        :$lib, :argfirst);
                }
            }
        }

        $return;
    }
    
    method build_routine (
        Str:D $routine where {any <sub method operator>},
        Str:D $result where {any <new rw mutator>},
        @args,
        :$lib!,
        Bool :$clear-line = True,
        Bool :$argfirst = False,
    ) {
        my $name;
        if $routine eq 'operator' {
            die "Symbolic operators cannot be used as a $result routine"
                unless $result eq 'new';
            
            $name =
                @args ?? "infix:<$.operator>" !!
                $.postfix ?? "postfix:<$.operator>" !!
                "prefix:<$.operator>";
        } else {
            $name = $result eq 'mutator' ?? $.mutator !! $.function;
        }

        my @params = "$lib.name():D \$";
        if @args {
            for @args {
                @params.push: "{$_ eq 'num' ?? 'Numeric' !! $lib.name}:D \$";
            }
        }

        my $params = '';
        my $var = 'a';
        my $is_method = ($routine eq 'method');
        @params.unshift: @params.splice(1,1) if $argfirst;
        for @params {
            $params ~= $is_method && $var eq 'b' ?? ' ' !! ', '
                if $params;
            $params ~= $_ ~ $var++;
            $params ~= ':' if $is_method && $var eq 'b';
        }

        if $.return {
            my $return =
                $.return eq 'obj' ?? "{$lib.name}:D" !!
                $.return eq 'num' ?? 'Numeric:D' !!
                $.return;

            if $result eq 'rw' {
                if $params {
                    $params ~= ',' unless $is_method && $var eq 'b';
                    $params ~= ' ' if $params;
                }
                $params ~= "$return \$r is rw";
            }
            $params ~= " --> $return";
        } else {
            #$params ~= " --> Nil";
        }

        my $beginning = "multi {$routine eq 'method' ?? 'method' !! 'sub'} $name ($params) ";
        $beginning ~= 'is pure ' if $result eq 'new';
        $beginning ~= 'is export ' if $routine ne 'method';
        $beginning ~= '{';
        
        my $build = "$beginning\n{
            self.build_routine_body($routine, $result, @args, :$lib, :$argfirst)\
                .indent(4)
        }\n\}";
        $build ~= "\n\n" if $clear-line;
        
        $build;
    }

    method build_routine_body (
        Str:D $routine,
        Str:D $result,
        @args,
        :$lib!,
        Bool :$argfirst = False,
    ) {
        my $return = '';
        $return ~= "$.intro\n\n" if $.intro;

        return "$return$.body" if $.body;
        
        my $expression = self.build_routine_expression(@args, :$lib, :$argfirst);
        
        if $.return eq 'obj' {
            $expression .= indent(4);
            if $result eq 'new' {
                $return ~= "{$lib.name}.new(\n$expression\n);";
            } else {
                my $r = $result eq 'rw' ?? '$r' !! $argfirst ?? '$b' !! '$a';
                my $i = 0;
                $return ~= "({(^$lib.elems).map({"$r\[$_]"}).join(',')}) =\n$expression;\n$r;";
            }
        } elsif $.return eq 'num' {
            if $result eq 'new' {
                $return ~= $expression;
            } elsif $result eq 'rw' {
                $return ~= "\$r = $expression;";
            } else {
                die "Cannot autogenerate $result routine for this operation:\n{self.perl}";
            }
        }

        $return;
    }
    
    method build_routine_expression (@args, :$lib!, Bool :$argfirst = False) {
        return $.expression if $.expression;

        my $return;

        if $.return eq 'obj' {
            $return = self.build_routine_expressions(@args, :$lib, :$argfirst).join(",\n");
        } elsif $.return eq 'num' {
            die "Cannot autogenerate this operation:\n{self.perl}"
                unless $.operator && (!@args || @args == 1 && @args[0] eq 'num');

            my $op = $.operator;
            
            if @args {
                $return = "\$a $op \$b";
            } else {
                $return = "$op\$a";
            }
        }
        
        $return;
    }

    method build_routine_expressions (@args, :$lib!, Bool :$argfirst) {
        return @.expressions if @.expressions;

        die "Cannot autogenerate this operation:\n{self.perl}"
            unless $.operator && @args <= 1;

        my $op = $.operator;
        my @expressions;
        
        if @args {
            my $map_expr = $argfirst ??
                {     "\$a $op \$b[$_]" } !!
                { "\$a[$_] $op \$b"     };
            @expressions = (^$lib.elems).map($map_expr);

            if @args[0] eq 'obj' {
                my $i = 0;
                @expressions .= map: { "$_\[{$i++}]" };
            }
        } else {
            @expressions = (^$lib.elems).map({"$op \$a[$_]"});
        }

        @expressions;
    }
}

class Math::ThreeD::Library {
    has Str:D $.name;
    has Numeric:D $.elems;
    has Str $.intro;
    has Str $.constructor;
    has Math::ThreeD::Operation:D @.ops;

    method build () {
        my $build = "class $.name is Array;\n\n";

        $build ~= "$.intro\n\n" if $.intro;
        
        $build ~=
            qq[method perl () \{ '{$.name}.new(' ~ join(',', self.list».perl) ~ ')' }\n\n];
        if $.constructor -> $_ {
            $build ~= "sub $_ (|a) is export \{ {$.name}.new(|a) }\n\n";
        }

        if @.ops {
            for @.ops {
                $build ~= .build(lib => self);
            }
        }

        $build;
    }

    method write (Str:D $filename) {
        chdir $?FILE.path.directory;
        mkpath($filename.path.parent);
        my $out = $filename.path.open(:w);
        $out.print: self.build;
        $out.close;
    }
}

sub op (|a) is export { Math::ThreeD::Operation.new(|a) }

# vim: set expandtab:ts=4:sw=4
