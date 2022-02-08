echo $(date);
time grep -P ".*,SESN,.*Func=(?!Wait|Attach|Start|Finish|Busy).*" ADMIN/*/*.log |
perl -pe 's/\xef\xbb\xbf//g' |
perl -pe 's/-\d+,SESN,\d//' |
perl -pe 's/,p:processName=.*,Func=/,Func=/' |
perl -pe 's/\w+-\w+-\w+-\w+-\w+/{GUID}/g' |
sort -nb;
echo $(date);
