echo $(date);
time grep -P ".*недостаточно прав.*" -C 5 EXCP/*/*.log |
awk -vORS= '{if(match($0, "^EXCP/(rphost|ragent|1cv8c)_[0-9]+/[0-9]+\.log(\-|\:)[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0 "<NL>";}' |
perl -pe 's/\xef\xbb\xbf//g' |
grep -P '.*недостаточно прав.*' |
perl -pe 's/^EXCP\/rphost_\d+\/22//g' |
perl -pe 's/^EXCP\/ragent_\d+\/22//g' |
perl -pe 's/^EXCP\/1cv8c_\d+\/22//g' |
awk -F'.log' '{
	count[$1] += 1;
	total_cnt += 1;
} END {
	printf "%10d total cnt\n", total_cnt;

	for(i in count) {
		printf "%s %10d cnt\n", i, count[i]
	}
}' |
sort -nb |
perl -pe 's/<NL>/\n/g';
echo $(date);
