# Топ суммарно длительных вызовов
# Суммарная длительность :: База :: Вызов
echo $(date);

TopEntitiesCount="$1";
if [ -z "$1" ]
then TopEntitiesCount=10
fi

ShowBaseName="$2"
if [ -z "$2" ]
then ShowBaseName=0;
fi

ShowBaseUsrName="$3"
if [ -z "$3" ]
then ShowBaseUsrName=0;
fi

rphostFilter="CALL/rphost_*/*.log";
echo rphostFilter $rphostFilter;
printf "%12s %8s %8s %8s %8s %8s %8s %8s %8s %s\n", "MemPeakKB", "MemMB", "sec", "avrg", "max", "cnt", "OutMB", "InMB", "Cpu_sec", "Context" \
; printf "%s\n" \
; time cat $rphostFilter | \
awk -vORS= '{if(match($0, "^[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0;}' |
perl -pe 's/\xef\xbb\xbf//g' |
grep -P ',.*CALL,.*p:processName' |
awk -v ShowBaseNameAWK=$ShowBaseName -v ShowBaseUsrNameAWK=$ShowBaseUsrName '{
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
	
 ToAdd = 0; # определяет, выполнять ли проверку в массиве и добавление, т.е. пропускать строку или нет
 
 posFunc = match($0, ",Func=");
 if(posFunc!=0) # у регламентных заданий так
 { 
  ToAdd = 1;
  posSessionID = match($0, ",SessionID");
  posUsr = match($0, ",Usr");
  if(ShowBaseUsrNameAWK > 0) UsrName = substr($0, posUsr + 1, (posSessionID - posUsr - 1));
  
  posBase = match($0, "p:processName=");
  LenBase = posFunc - posBase;
  if(ShowBaseNameAWK > 0) {
  pBase = substr($0, posBase, LenBase);
  gsub("p:processName", "Base", pBase);
  }
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
   ToAdd = 1;
   posSessionID = match($0, ",SessionID");
  posUsr = match($0, ",Usr");
  if(ShowBaseUsrNameAWK > 0) UsrName = substr($0, posUsr + 1, (posSessionID - posUsr - 1));
  
   posBase = match($0, "p:processName=");
   postOSThread = match($0, ",OSThread=");
   LenBase = postOSThread - posBase;
   if(ShowBaseNameAWK > 0) {
   pBase = substr($0, posBase, LenBase);
   gsub("p:processName", "Base", pBase);
   }
   strContexMore = substr($0, posContext+1);
   posEndContext = match(strContexMore, ",");
   Context = substr(strContexMore, 1, posEndContext - 1);
  }
 }
 
	KeyStr = pBase " :: " Context " :: " UsrName; 
 
 if(ToAdd==1)
 {
	posOutBytes = match($0, ",OutBytes=");
	OutBytes = substr($0, posOutBytes + length(",OutBytes="), posCpuTime - posOutBytes + length(",OutBytes="));
	posInBytes = match($0, ",InBytes=");
	InBytes = substr($0, posInBytes + length(",InBytes="), posOutBytes - posInBytes - length(",InBytes="));
	posMemoryPeak = match($0, ",MemoryPeak=");
	MemoryPeak = substr($0, posMemoryPeak + length(",MemoryPeak="), posInBytes - posMemoryPeak - length(",MemoryPeak="));
	posMemory = match($0, ",Memory=");
	Memory = substr($0, posMemory + length(",Memory="), posMemoryPeak - posMemory - length(",Memory="));	
  
	if(posCpuTime == 0) {
		CpuTime = 0;
	}
	else {
		CpuTime = substr($0, posCpuTime + length(",CpuTime="));
		CpuTime = CpuTime / 1000000;
	}
	
	MemoryPeak = MemoryPeak / 1000;
 
	arr_dlits[KeyStr] += dlit;
	if(dlit_max[KeyStr] < dlit) dlit_max[KeyStr] = dlit;	
	arr_counts[KeyStr] += 1;
	arr_OutBytes[KeyStr] += OutBytes / 1000000;
	arr_InBytes[KeyStr] += InBytes / 1000000;
	if(arr_MemoryPeak[KeyStr] < MemoryPeak) arr_MemoryPeak[KeyStr] = MemoryPeak;
	arr_Memory[KeyStr] += Memory / 1000000;
	arr_CpuTime[KeyStr] += CpuTime;
 } 
} END {
	for (i in arr_dlits) {printf "%12d %8d %8d %8.2f %8.2f %8d %8d %8d %8d %s\n", arr_MemoryPeak[i], arr_Memory[i], arr_dlits[i],
	arr_dlits[i] / arr_counts[i], dlit_max[i], arr_counts[i], arr_OutBytes[i], arr_InBytes[i], arr_CpuTime[i], i}
}' | sort -rnb | head -n "$TopEntitiesCount";
echo $(date);