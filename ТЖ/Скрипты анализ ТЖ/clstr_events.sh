echo $(date);
time grep "" ADMIN/*/*.log |
awk -vORS= '{if(match($0, "[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0;}' |
grep -P ".*,CLSTR,.*,Event=(?!Successful service call|Connection assigned|Rebalance denied).*" |
perl -pe 's/\xef\xbb\xbf//g' |
perl -pe 's/\w+-\w+-\w+-\w+-\w+/{GUID}/g' |
sort -nb;
echo $(date);
