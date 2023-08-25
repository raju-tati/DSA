use v5.38;
use feature 'class';
no warnings 'experimental::class';

class Stack {
	my $array = [];
	
	method isEmpty() {
		return(scalar(@{$array}) == 0);
	}
	
	method push($value) {
		unshift(@{$array}, $value);
	}
	
	method pop() {
		return shift(@{$array});
	}
	
	method peek() {
		return $array->[0];
	}
	
	method size() {
		return scalar(@{$array});
	}
}
