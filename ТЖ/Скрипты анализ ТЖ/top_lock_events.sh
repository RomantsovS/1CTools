echo $(date);
printf "%6s %s\n", "cnt", "Context";
time cat TTIMEOUTTDEADLOCK/rphost*/*.log | \
#head -n 100 | \
awk -vORS= '{if(match($0, "^[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0;}' | \
perl -pe 's/\xef\xbb\xbf//g' | \
grep -P ".*(TDEADLOCK|TTIMEOUT).*" | \
perl -pe 's/^\d+:\d+.\d+-\d+,//g' | \
perl -pe 's/,\d+.*//g' | \
awk '{count[$0]+=1;} END {for(i in count) {printf "%10d cnt %s\n", count[i], i}}' | \
sort -rnb | \
head -n 10;
echo $(date);