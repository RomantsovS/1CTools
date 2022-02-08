# Топ суммарно длительных вызовов
# Суммарная длительность :: База :: Вызов
echo $(date);
printf "%8s %5s %8s %7s %7s %7s %10s %7s %10s %s\n", "sec", "min", "avrg", "cnt", "OutMB", "InMB", "MBMemPeak", "MBMem", "Cpu_sec", "Context" \
; printf "%s\n" \
; time cat CALL/rphost*/*.log |
#head -n 1000 |
awk -vORS= '{if(match($0, "^[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0;}' |
perl -pe 's/\xef\xbb\xbf//g' |
grep -P ',.*CALL,.*p:processName=.*' |
awk '{
ToAdd = 1; # определяет, выполнять ли проверку в массиве и добавление, т.е. пропускать строку или нет

 posDlit = match($0, "-");
 posCALL = match($0, ",.*CALL");
 LenDlit = posCALL - posDlit;
 dlit = substr($0, posDlit+1, LenDlit); #длительность вызова (для 8.2 1/10000 секунд, для 8.3 1/1000000 секунд)
 dlit = dlit / 1000000;
 
 posMemory = match($0, ",Memory=");
 posMemoryPeak = match($0, ",MemoryPeak=");
 posInBytes = match($0, ",InBytes=");
 posOutBytes = match($0, ",OutBytes=");
 
 Memory = substr($0, posMemory + 8, (posMemoryPeak - posMemory - 8));
 
 posCpuTime = match($0, ",CpuTime=");
 
 posBase = match($0, "p:processName=");
 
 Context = "<empty>"
 
 if(posBase != 0) {
  strProcessNameMore = substr($0, posBase + 1);
  posEndProcessName = match(strProcessNameMore, ",");
  pBase = substr(strProcessNameMore, 14, posEndProcessName - 14);
 } else {
	posBase = "<empty>"
 }
 
 posUsr = match($0, ",Usr");
 if(posUsr != 0) {
  strUsrNameMore = substr($0, posUsr + 1);
  posEndUsrName = match(strUsrNameMore, ",");
  UsrName = substr(strUsrNameMore, 5, posEndUsrName - 5);
 } else {
	UsrName = "<empty>"
 }
 
 UsrName = "<empty>"
 
 posFunc = match($0, ",Func=");
 if(posFunc!=0) # у регламентных заданий так
 {
  posMemory = match($0, ",Memory=");
  posModule = match($0, ",Module=");
  LenMethod = posMemory - posModule;
  Context = substr($0, posModule + 1, LenMethod - 1);
 }
 else # у пользовательских вызовов так
 {
  posContext = match($0, ",Context=");
  if(posContext!=0)
  {
   strContexMore = substr($0, posContext+1);
   posEndContext = match(strContexMore, ",");
   Context = substr(strContexMore, 1, posEndContext - 1);
  }
 }
 
	KeyStr = pBase " :: " Context " :: " UsrName; 
 
 if(ToAdd==1)
 {
	OutBytes = substr($0, posOutBytes + length(",OutBytes="), posCpuTime - posOutBytes + length(",OutBytes="));
	InBytes = substr($0, posInBytes + length(",InBytes="), posOutBytes - posInBytes - length(",InBytes="));
	MemoryPeak = substr($0, posMemoryPeak + length(",MemoryPeak="), posInBytes - posMemoryPeak - length(",MemoryPeak="));	
  
	if(posCpuTime == 0) {
		CpuTime = 0;
	}
	else {
		CpuTime = substr($0, posCpuTime + length(",CpuTime="));
		CpuTime = CpuTime / 1000000;
	}
 
	arr_dlits[KeyStr] += dlit;
	arr_counts[KeyStr] += 1;
	arr_OutBytes[KeyStr] += OutBytes / 1000 / 1000;
	arr_InBytes[KeyStr] += InBytes / 1000 / 1000;
	if(arr_MemoryPeak[KeyStr] < MemoryPeak) arr_MemoryPeak[KeyStr] = MemoryPeak / 1000 / 1000;
	arr_Memory[KeyStr] += Memory / 1000 / 1000;
	arr_CpuTime[KeyStr] += CpuTime;
 } 
} END {
	for (i in arr_dlits) {printf "%8d %5d %8.2f %7d %7d %7d %10d %7d %10d %s\n", arr_dlits[i],
	(arr_dlits[i])/60, arr_dlits[i] / arr_counts[i], arr_counts[i], arr_OutBytes[i], arr_InBytes[i], arr_MemoryPeak[i], arr_Memory[i], arr_CpuTime[i], i}
}' | sort -rnb | head -n 30;
echo $(date);