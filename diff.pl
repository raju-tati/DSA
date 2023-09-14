use strict;
use warnings;

sub splitStringOnWords {
	my ($string) = @_;
	my @stringList = split("", $string);

	my @splitStringOnWords;
	my $subString = "";

	foreach my $element (@stringList) {
		if($element eq "\n") {
			push(@splitStringOnWords, $subString);
			push(@splitStringOnWords, "\n");
			$subString = "";
		}

		elsif($element ne " ") {
			$subString .= $element;
		}
		
		else {
			push(@splitStringOnWords, $subString);
			push(@splitStringOnWords, " ");
			$subString = "";
		}
	}

	push(@splitStringOnWords, $subString);
	return @splitStringOnWords;
}

sub printDiff {
	my ($stringOne, $stringTwo) = @_;
	
	my @stringOneList = splitStringOnWords($stringOne);
	my @stringTwoList = splitStringOnWords($stringTwo);
	
	my $stringOneCounter = 0;
	my $stringTwoCounter = 0;
	
	my $diff = [];
	
	my $matchedPart = "";
	my $unMatchedPart = "";

	my $lastStringTwoMatchedPosition = 0;

	while(1) {
		if($stringOneList[$stringOneCounter] eq $stringTwoList[$stringTwoCounter]) {	
			push(@{$diff}, ["unMatchedPart", $unMatchedPart]) if($unMatchedPart);
			$unMatchedPart = "";
			
			$matchedPart .= $stringOneList[$stringOneCounter];

			$stringOneCounter++;
			$stringTwoCounter++;
			$lastStringTwoMatchedPosition++;
		}
		
		else {
			push(@{$diff}, ["matchedPart", $matchedPart]) if($matchedPart);
			$matchedPart = "";
			$unMatchedPart .= $stringTwoList[$stringTwoCounter];
			$stringTwoCounter++;
		}

		if($stringOneCounter == scalar(@stringOneList)) { 	
			push(@{$diff}, ["matchedPart", $matchedPart]) if($matchedPart);
			push(@{$diff}, ["unMatchedPart", $unMatchedPart]) if($unMatchedPart);
			last;
		}
		
		if($stringTwoCounter == scalar(@stringTwoList) && $stringOneCounter < scalar(@stringOneList)) {
			$stringTwoCounter = $lastStringTwoMatchedPosition;
			push (@{$diff}, ["unMatchedPartInStringOne", $stringOneList[$stringOneCounter]]);
			$unMatchedPart = "";
			$stringOneCounter++;
			next;
		}
	
		if($stringTwoCounter == scalar(@stringTwoList)) {
			last;
		}
	}

	foreach my $diffElement (@{$diff}) {
		if($diffElement->[0] eq "unMatchedPartInStringOne") {
			print("+++ UnMatched Part In Source File\n", $diffElement->[1], "\n" );
		}
		
		if($diffElement->[0] eq "matchedPart") {
			print("### Matched Part in Source File\n", $diffElement->[1], "\n");
		}
		
		if($diffElement->[0] eq "unMatchedPart") {
			print("--- UnMatched Part in Destination File\n", $diffElement->[1], "\n" );
		}
	}
}

sub readFile {
	my ($fileName) = @_;
	my $fileContent = "";

	open(my $fh, '<', $fileName) || die("Cannot open file");
	{
		local $/;
		$fileContent = <$fh>;
	}
	
	close($fh);
	return $fileContent;
}

my $sourceFile = $ARGV[0];
my $destinationFile = $ARGV[1];

my $sourceFileText = readFile($sourceFile);
my $destinationFileText = readFile($destinationFile);

printDiff($sourceFileText, $destinationFileText);

# perl diff.pl sourceFile destinationFile
