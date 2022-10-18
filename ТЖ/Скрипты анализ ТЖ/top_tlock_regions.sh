echo $(date);
printf "%8s %5s %8s %6s %s\n", "sec", "min", "avrg", "cnt", "Context" \
; printf "%s\n" \
; time cat LOCKS/rphost*/*.log | \
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
	#UserName = substr($0, posUsr + 5, posRegions - posUsr - 5);
	Region = substr($0, posRegions + 9);
	dlit = substr($0, 1, posUsr);
	dlit = dlit / 1000000;
	
	KeyStr = Region " :: " UserName;
	
	sum[KeyStr]+=dlit; count[KeyStr]+=1;
} END {
	for(i in sum) {
		printf "%8d %5d %8.2f %6d %s\n", sum[i], sum[i] / 60, sum[i]/count[i], count[i], i
	}
}' | \
sort -rnb | \
head -n 30;
echo $(date);