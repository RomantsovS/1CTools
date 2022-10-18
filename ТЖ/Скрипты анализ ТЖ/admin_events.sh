echo $(date);
time grep -P ".*,ADMIN,.*Func=(?!getIBRegistry|regAuthenticate|getServerProcesses|getConnections|getSeances|getInfoBases,).*" ADMIN/*/*.log |
perl -pe 's/\xef\xbb\xbf//g' |
perl -pe 's/-\d+,ADMIN,\d//' |
perl -pe 's/\w+-\w+-\w+-\w+-\w+/{GUID}/g' |
sort -nb;
echo $(date);
