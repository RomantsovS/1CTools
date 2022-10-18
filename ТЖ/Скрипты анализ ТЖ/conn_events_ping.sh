echo $(date);
time grep -P ".*,CONN,.*packetsLost=" ADMIN/*/*.log |
awk -vORS= '{if(match($0, "^ADMIN/(rphost|ragent|1cv8c|1cv8|1CV8C)_[0-9]+/[0-9]+\.log(\-|\:)[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0 "<NL>";}' |
perl -pe 's/\xef\xbb\xbf//g' |
perl -pe 's/:\d+:\d+.\d+-//g' |
perl -pe 's/ADMIN\///g' |
perl -pe 's/\d+,CONN.*,packetsSent=/,/g' |
perl -pe 's/avgResponseTime.*packetsLost=//g' |
perl -pe 's/packetsLostAndFound=//g' |
perl -pe 's/.log//g' |
awk -F ',' '{
	count_sent[$1] += $2;
	count_lost[$1] += $3;
	count_lost_found[$1] += $4;
	total_cnt += 1;
} END {
	printf "%30d total ping cnt\n", total_cnt;

	for(i in count_sent) {
		printf "%30s %10d sent %10d lost %10d found packets\n", i, count_sent[i], count_lost[i], count_lost_found[i]
	}
}' |
sort |
perl -pe 's/<NL>/\n/g';
echo $(date);
