echo $(date);
time grep -hP ".*,EXCPCNTX,.*" ADMIN/*/*.log |
perl -pe 's/\xef\xbb\xbf//g' |
sort -nb;
echo $(date);
