# BCT
BCT is Matlab toolbox which is designed to compare between biclustering algorithms.
You can compare between these algorithms based on many points:
1. The percentage of enriched biclusters for each algorithm.
2. The ability of the algorithms to recover selected patterns.
BCT block diagram is shown in Figure 1. First, as illustrated in this figure BCT input are the
biclustering output files, which contains the biclusters results from biclustering algorithms which
are implemented in BCT or implemented in one of available biclustering toolbox like BicAT
toolbox ,Bivisu program , ……
Second, function enrichment was analyzed for each biclusters using GeneMerge Perl program by
setting sufficient significance level and interested GO category. Third, as the number of generated
biclusters varies strongly among the considered methods, a postprocessing filtration procedure
has been applied to the output of the algorithms to provide a common basis for the comparison.
Finally, using one of comparison methodology which was implemented in BCT, the user could
test the performance of various algorithms.
![alt text](https://github.com/FADHLyemen/BCT/blob/master/image.png)
Please read BCT manual for more details:

https://github.com/FADHLyemen/BCT/blob/master/bct_manual.pdf
