echo $(date);

ShowBaseUsrName="$1"
if [ -z "$1" ]
then ShowBaseUsrName=0;
fi

printf "%6s %s\n", "cnt", "Context" \
; printf "%s\n" \
; time cat TTIMEOUTTDEADLOCK/rphost*/*.log |
awk -vORS= '{if(match($0, "^[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0 "<line>";}' |
perl -pe 's/\xef\xbb\xbf//g' |
grep -P ".*TDEADLOCK.*" |
perl -pe 's/^\d+:\d+.\d+-//g' |
perl -pe 's/,AppID=1CV8C//g' |
awk -v ShowBaseUsrNameAWK=$ShowBaseUsrName '{
	posContext = match($0, ",Context=");
	Context = substr($0, posContext + 9);
	
	posProcessName = match($0, ",p:processName=");
	posOSThread = match($0, ",OSThread=");
	
	BaseName = substr($0, posProcessName + length(",p:processName="), posOSThread - posProcessName - length(",p:processName="));
	
	posUsr = match($0, ",Usr=");
	posDBMS = match($0, ",DBMS=");
	
	if(ShowBaseUsrNameAWK > 0) UsrName = substr($0, posUsr + length(",Usr="), posDBMS - posUsr - length(",Usr="));

	Context = BaseName " :: " Context " :: " UsrName;
	
	count[Context]+=1;
} END {
	for(i in count) {
		printf "%6d %s\n", count[i], i
	}
}' |
sort -rnb |
head -n 30 |
perl -pe 's/<line>/\n/g';
echo $(date);