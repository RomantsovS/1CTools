echo $(date);
printf "%15s %25s", "cnt", "base" \
; printf "%s\n" \
; time cat rphost_*/*.log |\
awk -vORS= '{if(match($0, "^[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0 "<line>";}' |\
perl -pe 's/\xef\xbb\xbf//g' |\
perl -pe 's/^\d+:\d+.\d+-//g' |\
perl -pe 's/.*processName=//g' |\
awk -F',' '{count[$1]+=1;} END {for(i in count) {printf "%15d %25s\n",count[i], i}}' |\
sort -rnb |\
head -n 30;
echo $(date);