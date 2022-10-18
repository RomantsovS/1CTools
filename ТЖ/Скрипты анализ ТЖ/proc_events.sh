echo $(date);
time grep -P ".*,PROC,.*" ADMIN/*/*.log |
perl -pe 's/\xef\xbb\xbf//g' |
perl -pe 's/-\d+,PROC,\d//' |
perl -pe 's/,OSThread=\d+//' |
perl -pe 's/\w+-\w+-\w+-\w+-\w+/{GUID}/g' |
sort -nb;
echo $(date);
