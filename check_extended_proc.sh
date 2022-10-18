find . -name '*.bsl' -exec cat {} \; |
grep -P '&(ИзменениеИКонтроль|Перед|После|Вместо)\(' |
perl -pe 's/&(ИзменениеИКонтроль|Перед|После|Вместо)\(\"//g' |
perl -pe 's/\"\)//g' |
awk '{
	count[$1]+=1;
} END {
	for(i in count) {
		if(count[i] > 1) printf "****%10d cnt %s\n", count[i], i
	}
}' |
sort -rnb
