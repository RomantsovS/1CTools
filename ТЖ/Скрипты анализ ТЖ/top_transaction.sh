echo $(date);

ShowBaseUsrName="$1"
if [ -z "$1" ]
then ShowBaseUsrName=0;
fi

printf "%8s %8s %8s %6s %s\n", "sec", "avrg", "max", "cnt", "Context" \
; printf "%s\n" \
; time cat SDBL/rphost*/*.log | \
#head -n 100000 | \
awk -vORS= '{if(match($0, "^[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0 "<line>";}' | \
perl -pe 's/\xef\xbb\xbf//g' | \
grep -P "SDBL.*Func=(Commit|Rollback)Transaction.*Context" | \
perl -pe 's/^\d+:\d+.\d+-//g' | \
perl -pe 's/,OSThread=\d+//g' |
perl -pe 's/,AppID=(1CV8C|WebClient)//g' |
awk -v ShowBaseUsrNameAWK=$ShowBaseUsrName '{
	posContext = match($0, ",Context=");
	Context = substr($0, posContext + 9);
	
	posSDBL = match($0, ",SDBL");
	dlit = substr($0, 1, posSDBL);
	dlit = dlit / 1000000;
	
	posProcessName = match($0, ",p:processName=");
	posclientID = match($0, ",t:clientID");
	
	BaseName = substr($0, posProcessName + length(",p:processName="), posclientID - posProcessName - length(",p:processName="));
	
	posUsr = match($0, ",Usr=");
	posDBMS = match($0, ",DBMS=");
	
	if(ShowBaseUsrNameAWK > 0) UsrName = substr($0, posUsr + length(",Usr="), posDBMS - posUsr - length(",Usr="));

	Context = BaseName " :: " Context " :: " UsrName;
	
	sum[Context]+=dlit;
	count[Context]+=1;
	
	if(dlit_max[Context] < dlit) dlit_max[Context] = dlit;
} END {
	for(i in sum) {
		printf "%8.2f %8.2f %8.2f %6d %s\n", sum[i], sum[i]/count[i], dlit_max[i], count[i], i
	}
}' | \
sort -rnb | \
perl -pe 's/<line>/\n/g' |
head -n 30;
echo $(date);