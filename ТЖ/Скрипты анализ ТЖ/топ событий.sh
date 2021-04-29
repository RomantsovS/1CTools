echo $(date);
cat rphost_22956/*.log | \
#head -n 10 | \
awk -vORS= '{if(match($0, "^[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0 "<line>";}' | \
perl -pe 's/\xef\xbb\xbf//g' | \
perl -pe 's/^\d+:\d+.\d+-//g' | \
awk -F',' '{
	count[$2]+=1;
	sum[$2]+=$1 / 1000000;
} END {
	for(i in count) {
		printf "\t****%8d sec %5d min %5d %6.2f cnt %s\n", sum[i], sum[i] / 60, sum[i] / count[i], count[i], i
	}
}' |\
sort -rnb | \
head -n 30;
echo $(date);
