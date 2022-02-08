echo $(date);
cat LEAKS/*/*.log |
awk -vORS= '{if(match($0, "^[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0 "<NL>";}' |
perl -pe 's/\xef\xbb\xbf//g' |
grep -P ',.*,Descr=.*' |
perl -pe 's/^\d+:\d+.\d+-//g' |
perl -pe 's/\w+-\w+-\w+-\w+-\w+/{GUID}/g' |
awk -F'Descr=' '{
	count[$2]+=1;
} END {
	for(i in count) {
		printf "****%10d cnt %s\n", count[i], i
	}
}' |
sort -rnb |
perl -pe 's/<NL>/\n/g' |
head -n 100;
echo $(date);
