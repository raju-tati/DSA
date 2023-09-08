use strict;
use warnings;

my $trace = "";
my $count = 0;
my $tabSpace = "|___";
my $progressList = [];

sub listProgress {
	my ($element) = @_;
	push(@{$progressList}, $element);
	my $list;
	$list .= $_ . ", " foreach (@{$progressList});
	return "[" . $list . "]";
}

sub linearSum {
	my ($list, $number) = @_;

	my $t = $number . " - progess " . listProgress($number);
	my $indentSpace = $tabSpace x $count;
	
	$count++;
	$trace = $indentSpace . $t;

	my $input = <STDIN>;
	print $trace;

	if($number == 0) {
		return $list->[0];
	} else {
		return $list->[$number] + linearSum($list, $number -1);
	}
}

my $list = [1,2,3,4,5,6,7,8,9];
my $sum = linearSum($list, 6);

print "\n" x 2 . "sum is: " . $sum, "\n";
