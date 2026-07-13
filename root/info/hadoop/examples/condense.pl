#!/usr/bin/perl

undef $currentKey;
@vals=();

while (<STDIN>) {
    chomp();
    processRow(split(/\t/));
}

output();

sub output() {
    print $currentKey . "\t" . join(",", sort @vals) . "\n";    
}

sub processRow() {
    my ($k, $v) = @_;

    if (! defined($currentKey)) {
	$currentKey = $k;
	push(@vals, $v);
	return;
    }

    if ($currentKey ne $k) {
	output();
	$currentKey = $k;
	@vals=($v);
	return;
    }

    push(@vals, $v);
}
