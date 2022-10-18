echo $(date);
time cat EXCP/*/*.log |
awk -vORS= '{if(match($0, "^[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0 "<NL>";}' |
perl -pe 's/\xef\xbb\xbf//g' |
grep -P '.*,(EXCP|QERR|CALL),.*,(Descr|RetExcp)=.*' |
perl -pe 's/,RetExcp=/,Descr=/g' |
perl -pe 's/,Memory=.*//g' |
perl -pe 's/^\d+:\d+.\d+-//g' |
perl -pe 's/\w+-\w+-\w+-\w+-\w+/{GUID}/g' |
perl -pe 's/\.cpp\(\d+\)/\.cpp\(*\)/g' |
awk -F'Descr=' '{
	count[$2]+=1;
} END {
	for(i in count) {
		printf "****%10d cnt %s\n", count[i], i
	}
}' |
sort -rnb |
head -n 100 |
perl -pe 's/<NL>/\n/g';
echo $(date);
