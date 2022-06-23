echo $(date);

TopEntitiesCount="$1";
if [ -z "$1" ]
then TopEntitiesCount=10
fi

ShowBaseName="$2"
if [ -z "$2" ]
then ShowBaseName=0;
fi

ShowBaseUsrName="$3"
if [ -z "$3" ]
then ShowBaseUsrName=0;
fi

printf "%10s %10s %10s %10s %s\n", "sec", "avrg", "max", "cnt", "Context" \
; printf "%s\n" \
; time cat QUERIES/*/*.log |
#head -n 10000 |
awk -vORS= '{if(match($0, "[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0 "<line>";}' |
perl -pe 's/\xef\xbb\xbf//g' |
grep -P "(DBMSSQL|DBPOSTGRS).*Context" |
#grep -P "(DBMSSQL|DBPOSTGRS)" |
perl -pe 's/^\d+:\d+.\d+-//g' |
perl -pe 's/\w+-\w+-\w+-\w+-\w+/{GUID}/g' |
perl -pe 's/0[xX][0-9a-fA-F]+/{GUID}/g' |
perl -pe 's/,(DBMSSQL|DBPOSTGRS),.*,p:processName=/,;,/g' |
perl -pe 's/,Usr=/,;,/g' |
perl -pe 's/,Sql=.*,Context=/,;,/g' |
perl -pe 's/\(\d+\)/({NUM})/g' |
perl -pe 's/tt\d+/{TempTable}/g' |
awk -F',;,' -v ShowBaseNameAWK=$ShowBaseName -v ShowBaseUsrNameAWK=$ShowBaseUsrName '{
	if(ShowBaseNameAWK > 0) BaseName = $2;
	if(ShowBaseUsrNameAWK > 0) UsrName = $3;
	Context = BaseName"::"$4"\t::"UsrName;
	count[Context] += 1;
	
	dlit_cur = $1 / 1000000;
	dlit[Context] += dlit_cur;
	
	if(dlit_max[Context] < dlit_cur) dlit_max[Context] = dlit_cur;
	}
 END {
	for(i in count) {
		printf "%10.2f %10.2f %10.2f %10d %s\n", dlit[i], dlit[i] / count[i], dlit_max[i], count[i], i
	}
}' |
sort -rnb |
head -n "$TopEntitiesCount" |
perl -pe 's/<line>/\n/g';
echo $(date);