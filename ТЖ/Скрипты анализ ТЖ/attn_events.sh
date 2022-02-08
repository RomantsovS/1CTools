echo $(date);
time grep -P ".*,ATTN,.*" ADMIN/*/*.log |
perl -pe 's/\xef\xbb\xbf//g' |
sort -nb;
echo $(date);
