function rez=LAS_scoreBinary(sum, subrows, subcols, mrows, mcols, P)

cnrows = gammaln(mrows+1) - gammaln(subrows+1) - gammaln(mrows-subrows +1);
%ln(m choose k)

cncols = gammaln(mcols+1) - gammaln(subcols+1) - gammaln(mcols-subcols +1);
%ln(n choose l)

%rest = log(normcdf(-sum,0,sqrt(subrows*subcols)));


%ar = sum./sqrt(subrows.*subcols);

%rest2 = - ar.^2/2 + log( erfcx(ar/sqrt(2))/2 );

N = subrows.*subcols;
rest = log(binocdf(N-sum, N, 1-P));

%logBinopdf = gammaln(N+1) - gammaln(sum+1) - gammaln(N-sum +1)+sum*log(P)+(N-sum)*log(1-P);
%rest = log(binopdf(sum, subrows.*subcols, P));

rez = -rest - cnrows - cncols;