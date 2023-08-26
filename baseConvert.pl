use v5.38;
use strict;
use warnings;
use POSIX;

require './stack.pl';

sub baseConvert {
	my ($decimalNumber, $base) = @_;
	my @digits = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'A', 'B', 'C', 'D', 'E', 'F');
	my $remainderStack = Stack->new();
	
	while($decimalNumber > 0) {
		$remainderStack->push($decimalNumber % $base);
		$decimalNumber = floor($decimalNumber / $base);
	}
	
	my $newString = "";
	while(! $remainderStack->isEmpty()) {
		$newString .= $digits[$remainderStack->pop()];
	}
	
	return $newString;
}

print(baseConvert(25, 16));
