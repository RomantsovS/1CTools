echo $(date);
time grep -hP ".*,CONN,.*" ADMIN/*/*.log |
#head -n 50 |
perl -pe 's/\xef\xbb\xbf//g' |
perl -pe 's/-\d+,CONN,\d//' |
perl -pe 's/,OSThread=\d+//' |
#perl -pe 's/\w+-\w+-\w+-\w+-\w+/{GUID}/g' |
sort -nb;
echo $(date);
