echo $(date);
rphostFilter="rphost_*";
echo rphostFilter $rphostFilter;

TopEntitiesCount="$1";
if [ -z "$1" ]
then TopEntitiesCount=30
fi

ShowBaseName="$2"
if [ -z "$2" ]
then ShowBaseName=0;
fi

ShowBaseUsrName="$3"
if [ -z "$3" ]
then ShowBaseUsrName=0;
fi

#cat $rphostFilter/*.log | \
cat $rphostFilter/*.log | \
#head -n 100 | \
awk -vORS= '{if(match($0, "^[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0 "<line>";}' | \
perl -pe 's/\xef\xbb\xbf//g' | \
grep -P "DBMSSQL.*Context" | \
perl -pe 's/^\d+:\d+.\d+-//g' | \
perl -pe 's/Context.*<line>[ \t]+/Context=/g' | \
perl -pe 's/\w+-\w+-\w+-\w+-\w+/{GUID}/g' | \
perl -pe 's/0[xX][0-9a-fA-F]+/{GUID}/g' | \
perl -pe 's/\(\d+\)/({NUM})/g' | \
perl -pe 's/tt\d+/{TempTable}/g' | \
awk -v ShowBaseNameAWK=$ShowBaseName -v ShowBaseUsrNameAWK=$ShowBaseUsrName '{
	posContext = match($0, ",Context=");
	if(posContext != 0) {
		Context = substr($0, posContext + 9);
		gsub("<line>", "", Context);
	}
	else {
		posSql = match($0, ",Sql=");
		Context = substr($0, posSql + 5);
		if(length(Context > 200)) {
			Context = "SQL QUERY"
		}
		gsub("<line>", "\t", Context);
	}
	
	posProcessName = match($0, ",p:processName=");
	posclientID = match($0, ",t:clientID=");
	
	if(ShowBaseNameAWK > 0) BaseName = substr($0, posProcessName + length(",p:processName="), posclientID - posProcessName - length(",p:processName="));
	
	posTrans = match($0, ",Trans");
	posUsr = match($0, ",Usr");
	
	if(ShowBaseUsrNameAWK > 0) UsrName = substr($0, posUsr + 1, (posContext - posUsr - 1));
  
	Context = BaseName " :: " Context " :: " UsrName;
	
	posDBMSSQL = match($0, ",DBMSSQL");
	dlit = substr($0, 1, posDBMSSQL - 1);
	dlit = dlit / 1000000;
	
	if(dlit > 0) {
		sum[Context]+=dlit; count[Context]+=1;
		if(maxdlit[Context] < dlit) {
			maxdlit[Context] = dlit;
		}
	}
} END {
	printf " *   sec     min     avrg     max    cnt     Context\n"
	for(i in sum) {
		printf " *%8d %5d %8.2f %7.2f %6d %s\n", sum[i], sum[i] / 60, sum[i] / count[i],
		maxdlit[i], count[i], i}
}' | \
sort -rnb | \
head -n "$TopEntitiesCount";
echo $(date);