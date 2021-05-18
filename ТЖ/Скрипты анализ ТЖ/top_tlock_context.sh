echo $(date);
rphostFilter="rphost_*";
echo rphostFilter $rphostFilter;
printf "%8s %5s %8s %6s %s\n", "sec", "min", "avrg", "cnt", "Context" \
; printf "%s\n" \
; time cat $rphostFilter/*.log | \
#head -n 100000 | \
awk -vORS= '{if(match($0, "^[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0 "<line>";}' | \
perl -pe 's/\xef\xbb\xbf//g' | \
grep -P ",TLOCK,.*WaitConnections=\d+.*,Context" | \
perl -pe 's/^\d+:\d+.\d+-//g' | \
#perl -pe 's/,TLOCK,.*Context=/,Context=/g' | \
perl -pe 's/Context.*<line>[ \t]+/Context=/g' | \
perl -pe 's/<line>//g' | \
awk '{
	posContext = match($0, ",Context=");
	Context = substr($0, posContext + 9);
	
	posTLOCK = match($0, ",TLOCK");
	dlit = substr($0, 1, posTLOCK);
	dlit = dlit / 1000000;
	
	posProcessName = match($0, ",p:processName=");
	posclientID = match($0, ",t:clientID=");
	
	BaseName = substr($0, posProcessName + length(",p:processName="), posclientID - posProcessName - length(",p:processName="));

	Context = BaseName " :: " Context " :: " UsrName;
	
	sum[Context]+=dlit;
	count[Context]+=1;
} END {
	for(i in sum) {
		printf "%8d %5d %8.2f %6d %s\n", sum[i], sum[i] / 60, sum[i]/count[i], count[i], i
	}
}' | \
sort -rnb | \
head -n 30;
echo $(date);