# Топ суммарно длительных вызовов
# Суммарная длительность :: База :: Вызов
echo $(date);
printf "%15s %10s %s\n", "Mem(Mb)", "Count", "Context" \
; printf "%s\n" \
; time cat CALL/rphost*/*.log |
awk -vORS= '{if(match($0, "[0-9][0-9]\:[0-9][0-9]\.[0-9]+\-")) print "\n"$0; else print $0;}' |
perl -pe 's/\xef\xbb\xbf//g' |
grep -P '.*,CALL,.*' |
awk '{
    ToAdd = 1;

 posMemory = match($0, ",Memory=");
 posMemoryPeak = match($0, ",MemoryPeak=");
 
 Memory = substr($0, posMemory + 8, (posMemoryPeak - posMemory - 8));
 
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
 
 #UsrName = "<empty>"
 
 posFunc = match($0, ",Func=");
 if(posFunc != 0) # у регламентных заданий так
 {
  posModule = match($0, ",Module=");
  LenMethod = posMemory - posModule;
  Context = substr($0, posModule + 1, LenMethod - 1);
 }
 else # у пользовательских вызовов так
 {
  posContext = match($0, ",Context=");
  if(posContext != 0) {   
   strContexMore = substr($0, posContext + 1);
   posEndContext = match(strContexMore, ",");
   
   Context = substr(strContexMore, 1, posEndContext - 1);
  }
 }
 
 KeyStr = pBase " :: " Context " :: " UsrName;
 
 if(ToAdd == 1) {
    arr_Memory[KeyStr] += Memory / 1000 / 1000;
    arr_counts[KeyStr] += 1;
 }
} END {
	for (i in arr_Memory) {printf "%15d %10d %s\n", arr_Memory[i], arr_counts[i], i}
}' | sort -rnb | head -n 30;
echo $(date);