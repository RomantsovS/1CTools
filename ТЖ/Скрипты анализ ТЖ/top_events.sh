echo $(date);
time cat ADMIN/*/*.log |
#head -n 10 | \
awk -vORS= '{if(match($0, "^[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0 "<line>";}' |
perl -pe 's/\xef\xbb\xbf//g' |
perl -pe 's/^\d+:\d+.\d+-//g' |
awk -F',' '{
	count[$2]+=1;
} END {
	for(i in count) {
		printf "****%12d cnt %s\n", count[i], i
	}
}' |
sort -rnb |
head -n 30;
echo $(date);
