echo $(date);
time cat LOCKS/rphost*/*.log | \
awk -vORS= '{if(match($0, "^[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0 "<line>";}' | \
perl -pe 's/\xef\xbb\xbf//g' | \
grep -P ".*TDEADLOCK" | \
perl -pe 's/^\d+:\d+.\d+-//g' | \
perl -pe 's/.*TDEADLOCK,.*Context=/,Context=/g' | \
perl -pe 's/Context.*<line>[ \t]+/Context=/g' | \
perl -pe 's/<line>//g' | \
awk -F',Context=' '{
	count[$2]+=1;
} END {
	for(i in count) {
		printf "****%5d %s\n", count[i], i
	}
}' | \
sort -rnb | \
head -n 10;
echo $(date);