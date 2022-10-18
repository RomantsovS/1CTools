echo $(date);
time grep -hP ".*,QERR,.*" ADMIN/*/*.log |
perl -pe 's/\xef\xbb\xbf//g' |
sort -nb;
echo $(date);
