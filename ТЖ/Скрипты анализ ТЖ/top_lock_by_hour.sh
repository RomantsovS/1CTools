echo $(date);
time grep -P ".*блокировок.*" ADMIN/rphost_*/*.log |
awk -vORS= '{if(match($0, "^ADMIN.*/.*[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0 "<NL>";}' |
perl -pe 's/\xef\xbb\xbf//g' |
perl -pe 's/^ADMIN\/rphost_\d+\/220120//g' |
awk -F'.log' '{
	count[$1]+=1;
} END {
	for(i in count) {
		printf "****%10d cnt %s\n", count[i], i
	}
}' |
sort -rnb |
perl -pe 's/<NL>/\n/g' |
head -n 100;
echo $(date);
