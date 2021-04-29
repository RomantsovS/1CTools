echo $(date);
rphostFilter="rphost_*";
echo rphostFilter $rphostFilter;
cat $rphostFilter/*.log | \
#head -n 100000 | \
awk -vORS= '{if(match($0, "^[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0;}' | \
perl -pe 's/\xef\xbb\xbf//g' | \
grep -P ",TLOCK,.*WaitConnections=\d+.*,Context" | \
perl -pe 's/^\d+:\d+.\d+-//g' | \
perl -pe 's/,Locks=.*//g' | \
perl -pe 's/,WaitConnections=.*//g' | \
perl -pe 's/,TLOCK,.*Usr=/,Usr=/g' | \
awk '{
	posUsr = match($0, ",Usr=");
	posRegions = match($0, ",Regions=");
	UserName = substr($0, posUsr + 5, posRegions - posUsr - 5);
	Region = substr($0, posRegions + 9);
	dlit = substr($0, 1, posUsr);
	dlit = dlit / 1000000;
	
	KeyStr = Region " :: " UserName;
	
	sum[KeyStr]+=dlit; count[KeyStr]+=1;
} END {
	for(i in sum) {
		printf "\t****%7d sec %5d min %7.2f avrg %4d cnt %s\n", sum[i], sum[i] / 60, sum[i]/count[i], count[i], i
	}
}' | \
sort -rnb | \
head -n 30;
echo $(date);