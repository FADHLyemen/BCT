#!/usr/bin/perl -w

use POSIX;

# GeneMerge v1.2  - Windows version, only modification is writing of temp
#                   files to a Temp directory, and no unlinking of temp files
#                   March 2, 2004

#    GeneMerge-- Post-genomic analysis, data mining, and hypothesis testing
#    Copyright (C) 2003-2007 Cristian I. Castillo-Davis
#    castill0@stat.umd.edu

#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

########################################################################

# This program returns P-Values for functional enrichment in a cluster
# of study genes using the hypergeometric distribution, as well 
# functional descriptions for each gene. 

# Input on command line is as follows:

# file1 = a gene-association ID file
# file2 = a human readable description file for gene-association IDs 
# file3 = a population set of genes (the pool from which the study set
#         is drawn, often a genome or all genes on a microarray
# file4 = a study set of genes (for example, genes found up/down regulated)
# file5 = an output filename

#       n = # population genes
#       k = # study set genes
#       p = # of genes with a particular GMRG term divided by total genes (n)
#       r = # of genes in study set with a particular term

$version = "GeneMerge v1.2";

# intialize
$GMRGs_line_by_line = "";
$updownGMRGs_line_by_line = "";
$genes_GMRGterms = "";
$up_down_genes_with_annotation = 0;
$genes_not_found_in_ontology = "";
$GenesNoInfo = "";
$no_of_up_down_GMRG_terms = 0;
$BCr = 0;
$abort = "FALSE";

# Set input files and arguments

# format: genename \t GMRG id
$gene_association_file = $ARGV[0];

# format: GMRG id \t English description
$description_file = $ARGV[1];

# genenames of "population set"
$population_genes_file = $ARGV[2];

# genenames of "study set"
$study_genes_file = $ARGV[3];

####
# Usage output if no arguments given    # 1.2
if (($ARGV[0] eq "") || ($ARGV[0] eq "h") || ($ARGV[0] eq "-h")){
    print "\nSyntax:\n./GeneMerge.pl  gene-association.file  description.file  population.file  study.file  output.filename\n\n";
    $abort = "TRUE";
}
####


########################################   # 1.2
# Clean up line endings in input files #
# so that they are unix style.         #
########################################

if ($abort eq "FALSE") {
    
    # change line breaks in each file to Unix line breaks
    open(NFF,">Temp/pop_genes.temp");
    open(POP,"$population_genes_file");
    while(<POP>) {
	
	s/(\r\n?)+/\n/g;
	s/^\n//;
	print NFF $_;
    }
    close(POP);
    close(NFF);
    
    open(NFF2,">Temp/study_genes.temp");
    open(POP2,"$study_genes_file");
    while(<POP2>) {
	
	s/(\r\n?)+/\n/g;
	s/^\n//;
	print NFF2 $_;
	
    }
    close(POP2);
    close(NFF2);
    
    open(NFF,">Temp/gene_association_file.temp");
    open(POP,"$gene_association_file");
    while(<POP>) {
	
	s/(\r\n?)+/\n/g;
	s/^\n//;
	print NFF $_;
    }
    close(POP);
    close(NFF);
    
    open(NFF,">Temp/description_file.temp");
    open(POP,"$description_file");
    while(<POP>) {
	
	s/(\r\n?)+/\n/g;
	s/^\n//;
	print NFF $_;
    }
    close(POP);
    close(NFF);
    
######################################################################
# Main                                                               #
######################################################################

    # new filename for results file
    $results_filename = $ARGV[4];
    chomp($results_filename);
    
#######################################################################
# Hash GMRG Annotation data                                             #    
#######################################################################
    open(TARGET, "Temp/gene_association_file.temp") || die "couldn't open $gene_association_file";
    while(<TARGET>) {           # while new line, for each line evaluate
	
	if (/(.*)\t(.*)\n/) {
	    $genename = $1;
	    $annotation = $2;
	    #print "$genename\n";
	    chomp($annotation);
	    
	    # assign value genename to the key  
	    $GMRGgenomehash{$genename} = $annotation;
	}
    }
    print "Done parsing $gene_association_file\n";
    close(TARGET);
    
    
##########################################################################
# Retrieve GMRG terms for each gene in detected list and put into an array
# so that we can print them line by line to a new file.
##########################################################################
#print "Detected genes are:\n";
    open(SMALLFILE, "Temp/pop_genes.temp");
    while(<SMALLFILE>) {          
	
	$gene = $_;
	chomp($gene);
	#print "$gene\n";
	
	#count number of detected genes                                              ###############
	$total_no_detected_genes++;
	
	# do a lookup on the hash to get GMRGIDs associated with each gene we have
	# use "if" to see if gene was there... we keep track of these genes later
	if ($bigline = $GMRGgenomehash{$gene}) {
	    
	    #split $bigline using ; as a delimiter to put GMRGIDs into array
	    @indivGMRGs = split(/;/,$bigline);  
	    #get length of array
	    $length_of_indivGMRGs_array = $#indivGMRGs;
	    
	    for($v=0;$v<=$length_of_indivGMRGs_array;$v++) {
		
		$GMRGs_line_by_line = $GMRGs_line_by_line . "$indivGMRGs[$v]\n";
	    }
	} 
	
    }
    
    print "Number of population genes: $total_no_detected_genes\n";
    
#####################################################################################
# Print every GMRG term among detected genes to a file to create array-wide pool    #
# of GMRG terms. Then we can sort -u this file and count freq of GMRG terms in pool.#
#####################################################################################
    
#write GMRGIDs on indiv lines to file "SamplePoolGMRGIDs"
    open(NF, ">Temp/SamplePoolGMRGIDs");
#print "$GMRGs_line_by_line";
    print NF $GMRGs_line_by_line;
    close(NF);
    
# use sortu subroutine  to get a list of all unique GMRGIDs in this file
    $output = &sortu("Temp/SamplePoolGMRGIDs");
# print unique IDs to a file
    open(SORTED, ">Temp/uniqueGMRGIDs");
    print SORTED $output;
    close(SORTED);
    
# Count the frequency of each GMRGID in "Sample_GMRGIDs" (this is equivalent to counting the
# number of genes with a particular GMRG since each gene can have a GMRG associated only once)
# open up file with unique GMRGIDs present in the sample
    open(UNIQUEIDS, "Temp/uniqueGMRGIDs");
    while(<UNIQUEIDS>) {
	$count = 0;    
	$uniqueGMRGID = $_;
	chomp($uniqueGMRGID);
	
	#check each unique GMRG term against each line in the SampleGMRGID file to get freq counts
	# for each term
	open(SAMPLE,"Temp/SamplePoolGMRGIDs");
	while(<SAMPLE>) {
	    if(/\b$uniqueGMRGID\b/) {   # 1.1
		$count++;
	    }
	}
	close(SAMPLE);
	
	# get frequency of each GMRGID in the sample pool and write to a hash table
	if($uniqueGMRGID =~ /\S+/) {  # a check on blank lines
	    $frequency_of_GMRGID = $count/$total_no_detected_genes;
	    
	    # assign freq value to GMRGID key
	    $GMRGfreq_hash{$uniqueGMRGID} = $frequency_of_GMRGID;  
	    
	    # assign count to GMRGID key (count of GMRGID on array)  # 1.2
	    $GMRGcount_hash{$uniqueGMRGID} = $count;                 # 1.2
	    
	    print "$uniqueGMRGID = $count\t freq = $frequency_of_GMRGID\n";   	
	}   
}
    
###################################################################################
###################################################################################
# Determine GMRGID counts in up/down regulated genes                              #
###################################################################################
    
#print "Up\/Down genes are:\n";
    
    open(UPDOWNFILE, "Temp/study_genes.temp");
    while(<UPDOWNFILE>) {          
	
	$total_no_updown_genes++;
	
    $updowngene = $_;
	chomp($updowngene);
	#print "$updowngene\n";
	
	# do a lookup on the hash to get GMRGIDs associated with each gene we have
    # use "if" to check if gene was found at all in ontology
	if ($fullline = $GMRGgenomehash{$updowngene}) {
	    
	    
	    #split $fullline using ; as a delimiter to put GMRGIDs into array
	    @updownGMRGs = split(/;/,$fullline);  
	    
	    #get length of array
	    $length_of_updownGMRGs_array = $#updownGMRGs;
	    
	    for($b=0;$b<=$length_of_updownGMRGs_array;$b++) {
		$updownGMRGs_line_by_line = $updownGMRGs_line_by_line . "$updownGMRGs[$b]\n";
	    
	    }	    
	    
	    
	    #print GMRGIDs in array as is to save to a file later   
	$genes_GMRGterms = $genes_GMRGterms . "$updowngene\t$fullline\n";    
	} else { # if not save this information
	    $genes_not_found_in_ontology = $genes_not_found_in_ontology . "$updowngene\t";
	    $GenesNoInfo++;
	}
    }
    
    print "Number of study set genes: $total_no_updown_genes\n";
    
#write GMRGIDs on indiv lines to file "UpDownPoolGMRGIDs"
    open(NF, ">Temp/UpDownPoolGMRGIDs");
#print "$updownGMRGs_line_by_line";
    print NF $updownGMRGs_line_by_line;
    close(NF);
    
#write all updown Gene Names and GMRGIDs to a file 
    open(NF, ">Temp/gene_GMRGterms");
    print NF $genes_GMRGterms;
    close(NF);
    
    
## use sortu subroutine  to get a list of all unique GMRGIDs in study set file
    $output2 = &sortu("Temp/UpDownPoolGMRGIDs");
    
## print unique IDs to a file
    open(SORTED2, ">Temp/uniqueUpDownGMRGIDs");
    print SORTED2 $output2;
    close(SORTED2);
    
# use sort command to get a list of all unique GMRGIDs in UpDownGMRGIDs file
#system("sort -u UpDownPoolGMRGIDs > uniqueUpDownGMRGIDs");
    
# Count the frequency of each GMRGID in "UpDownPoolGMRGIDs"
# open up file with unique GMRGIDs present in the sample
    open(UNIQUEUPDOWNIDS, "Temp/uniqueUpDownGMRGIDs");
    while(<UNIQUEUPDOWNIDS>) {
	$counts = 0;    
	$unique_up_down_GMRGID = $_;
	chomp($unique_up_down_GMRGID);
	
	#check each one against each line in the UpDownPoolGMRGIDs file to get counts
	open(POOL,"Temp/UpDownPoolGMRGIDs");
	while(<POOL>) {
	    if(/\b$unique_up_down_GMRGID\b/) { # 1.1
		$counts++;
	    }
	}
	close(POOL);
	
	# get frequency of each GMRGID in the sample pool and write to a hash table
	if($unique_up_down_GMRGID =~ /\S+/) {  # a check on GMRGIDs that are blank     ## changed from GMRG to \w or \d ##
	    # assign count value to GMRGID count hash key
	    $updownGMRGcount_hash{$unique_up_down_GMRGID} = $counts;
	    
	    print "$unique_up_down_GMRGID\t$counts\n";
	    
	# count the number of unique GMRG terms in up/down genes
	    $no_of_up_down_GMRG_terms++;
	    # count the number of GMRG terms that are not represented only once on the array
	    # (these will be in frequency 1/total detected genes)
	    # we use this figure in Bonferroni correction later
	    if ($GMRGfreq_hash{$unique_up_down_GMRGID} > (1/$total_no_detected_genes)) {                                 
		$BCr++;
	    }
	}   
    }
    
    print "\n\nNumber of study set GMRGterms is = $no_of_up_down_GMRG_terms\nBCr = $BCr\n";
    
#Write contents of GMRGID count within up/down and freq w/in detected to a file
    open(NF, ">Temp/GMRGID_n_p_k_r");
    
    while(($key,$value) = each(%updownGMRGcount_hash)) {                                         
	# grab freq of the GMRGID in the detected sample from other hash
	$freq = $GMRGfreq_hash{$key};
	
	
	#         GMRGID  n                        p      k                     r(count)
    print NF "$key\t$total_no_detected_genes\t$freq\t$total_no_updown_genes\t$value\n";
	
    }
    close(NF);
    
################################################################
################################################################
# Part III - Get P-values for each GMRGID among up/down genes  #
#            using the hypergeometric distribution.            #
################################################################
    
    open(NF, ">Temp/GMRGID_P_Values");
    
    open(DATA,"Temp/GMRGID_n_p_k_r");
    while(<DATA>) {
	
	$p_value = 0;
	if (/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\n/) {
	
#	print "$1, $2, $3, $4, $5\n";
	    
	    my $GMRGid = $1; #
	    my $n = $2; #
	    my $p = $3; #
	    my $k = $4; #
	    my $r = $5; #
	    
	    # if not a singleton in up/down list
	    if ($r != 1) {
		
		# for r values from r (observed) through k (most extreme case) 
		# add together probabilities
		
		# add up starting with most extreme case first to 
		# hold onto significant figures
	    
		$p_value = &hypergeometric($n,$p,$k,$r);
		
		
		# Bonferroni correction for multiple tests
		$p_value_corrected = ($p_value * $BCr);
		if ($p_value_corrected >= 1.0) {
		    $p_value_corrected = 1.0;
		}
		print "pvalue is: $p_value\n";
		print "Bonferroni corrected pvalue is: $p_value_corrected\n";
	    } else {
	    
		$p_value = "NA";
		$p_value_corrected = "NA";
		
		print "pvalue is: $p_value\n";
		print "Bonferroni corrected pvalue is: $p_value_corrected\n";
	    }
	    
	    
	    
	    # grab gene names associated with each GMRG term
	    # from the up/down list
	    $gene_simmons = "";
	    open(GENE, "Temp/gene_GMRGterms");
	    while(<GENE>) {
	    
	    
		# parse line into gene names and GMRG terms
		if (/(.*)\t(.*)/) {
		    $GeneName = $1;
		    
		}
		# if the P-Value GMRGid matches a GMRGid for a particular gene
		# grab it and add it to the list
		if (/\b$GMRGid\b/) { # 1.1
		    $gene_simmons = $gene_simmons . "$GeneName\t"; 
		}
	    }
	    close(GENE);	
	    
#	print "$GMRGid $n, $p, $k, $r, prob = $p_value\n";
	    print NF "$GMRGid\t$n\t$p\t$k\t$r\t$p_value\t$p_value_corrected\t$gene_simmons\n";
	    
	}
	
    }
    close(NF);
    
# now use pre-parsed GMRG ontology table to look up functions for
# all up/down regulated genes
    open(ONTOLOGY, "Temp/description_file.temp");
    while(<ONTOLOGY>) {
    #parse each line to put function into a hash and GMRGterm as key
	if (/(.*)\t(.*)\n/) {
	    $GMRGkey = $1;
	    $function = $2;
	    $Ontology_Hash{$GMRGkey} = $function;
	    #print "        $GMRGkey\t$function\n";
	}
    }
    

# open this file and count how may up/down genes have no GMRGterms
# associated with them
    
    open(TEMP, "Temp/gene_GMRGterms");
    while(<TEMP>) {
	if (/(.*)\t(.*)/) {
	    # do nothing
	    $up_down_genes_with_annotation++;
	}
    }
    
    
##################################################################
# Parse final data - look up ontologies and generate output      #
##################################################################
    
    open(NF,">$results_filename");
#print header
    
    print NF "$version;  $results_filename\n\n";
    print NF "Gene Association File:  $gene_association_file\n";
    print NF "Description File:  $description_file\n";
    print NF "Population File:  $population_genes_file\n";
    print NF "Study File:  $study_genes_file\n\n";
    
    print NF "GMRG_Term\tPop_freq\tPop_frac\tStudy_frac\tRaw_es\te-score\tDescription\tContributing_genes\n";
    
    open(TEMPII, "Temp/GMRGID_P_Values");
    while(<TEMPII>) {
	
	#intitialize
    $genenames = "";
    
    # parse each line
    @FinalData = split(/\t/,$_);
    
    # get the length of the current array
    $arraylength = $#FinalData;
    
    # parse out relevant data for writing to final file and function lookup
    $GMRG_Term = $FinalData[0];
    #$allGMRGs_detected = $FinalData[1];
    $allupdownGMRGs = $FinalData[3];
    $r_in_updown = $FinalData[4];
    $pValue = $FinalData[5];
    $pValue_corrected = $FinalData[6];
    
    
    
    # Go through the array and parse out all gene names that contribute
    # to this GMRG term (could be one or more)
    for ($x=7;$x<$arraylength;$x++) {
	$genenames = $genenames . "$FinalData[$x]\t";
    }        
    # get function for this term from Ontology hash
    if ($this_function = $Ontology_Hash{$GMRG_Term}) {
	#everything is cool
    } else {
	$this_function = "couldn't find description for this term in $description_file";    # 1.2
    }
    
    # Get array count for this term                          # 1.2
    if ($array_count = $GMRGcount_hash{$GMRG_Term}) {        # 1.2
	#everything is cool
    } else {
	$array_count = "couldn't find array count";
    }

    #print output yeah!
    print NF "$GMRG_Term\t$GMRGfreq_hash{$GMRG_Term}\t$array_count/$total_no_detected_genes\t$r_in_updown\/$allupdownGMRGs\t$pValue\t$pValue_corrected\t$this_function\t$genenames\n";
    
}
    print NF "\nTotal number of genes: $total_no_detected_genes\n";
    print NF "Total number of Study genes: $total_no_updown_genes\n";
    print NF "Total number of Study gene GMRG terms (pop non-singletons): $no_of_up_down_GMRG_terms ($BCr)\n";
    print NF "Genes with GMRG information: $up_down_genes_with_annotation\n";
    print NF "Genes with no GMRG information: $GenesNoInfo\n";
    print NF "These are:\t$genes_not_found_in_ontology\t";
    
    close(TEMPII);
    close(NF);
    
#delete temp files ####### Not possible under Windows, so use a Temp dir instead
    
}


###############################################################
#                        SUBROUTINES                          # 
###############################################################

# Hypergeometric tail probability
#
# Returns one-tailed probability based on the hypergeometric distribution:
# the probability of witnessing r successes in a sample of k items from
# a pool of size n, with r having prob (proportion) p, sampling without
# replacement. Uses natural log n choose k and factorial subroutines.

sub hypergeometric {
    my $n = $_[0];
    my $p = $_[1];
    my $k = $_[2];
    my $r = $_[3];
    my $q;
    my $np;
    my $nq;
    my $top;
    
    $q = (1-$p);
    
    $np = floor( $n*$p + 0.5 );  # round to nearest int
    $nq = floor( $n*$q + 0.5 );

    $log_n_choose_k = &lNchooseK( $n, $k );

    $top = $k;
    if ( $np < $k ) {
	$top = $np;
    }

    $lfoo = &lNchooseK($np, $top) + &lNchooseK($n*(1-$p), $k-$top);
    $sum = 0;

    for ($i = $top; $i >= $r; $i-- ) {
	$sum = $sum + exp($lfoo - $log_n_choose_k);

	if ( $i > $r) {
	    $lfoo = $lfoo + log($i / ($np-$i+1)) +  log( ($nq - $k + $i) / ($k-$i+1)  )  ;
	}
    }
    return $sum;
}

# ln factorial subroutine
sub lFactorial {
    $returnValue = 0;
    my $number = $_[0];
    for(my $i = 2; $i <= $number; $i++) {
     	$returnValue = $returnValue + log($i);
    }
    return $returnValue;
}

# ln N choose K subroutine
sub lNchooseK {
    my $n = $_[0];
    my $k = $_[1];
    my $answer = 0;

    if( $k > ($n-$k) ){
	$k = ($n-$k);
    }

    for( $i=$n; $i>($n-$k); $i-- ) {
	$answer = $answer + log($i);
    }

    $answer = $answer - &lFactorial($k);
    return $answer;
}

# sort unique subroutine
sub sortu {
    
    #input is the filename to sort
    my $file = $_[0];

    #initialize
    my $term = "";
    my %uniquehash;
    my $ulist = "";

    open(F, "$file") || die "couldn't open $file";
    while(<F>) {           
	
	$term = $_;
	# make $term the key - this way it'll overwrite  
	$uniquehash{$term} = 1;    
    }
    close(F);
    
    @unique_array = keys(%uniquehash);
    
    for($qq = 0; $qq<=$#unique_array; $qq++) {
	$ulist = $ulist . $unique_array[$qq];
    }
    return $ulist; # return a unique list
}

