# Топ вызовов, максимально нагружающих процессор. На основе топа длительных вызовов.
# Часы:Минуты:Секунды : Длительность : Пользователь : База : Вызов  
# Свойство CpuTime содержит длительность завершившегося серверного вызова в микросекундах.
# Hour = 10; #Номер часа, за который нужно выбрать операции. Например, за 10й час.
y=0;
#grep -P ',CALL,' ./rphost*/*.log | head -n 10000 | awk '{
grep -P ',CALL,' ./rphost*/*.log | awk 'function OnlyNumbers(str1FULL)
 {   
    lenstr1FULL = length(str1FULL);
    strOnlyNumbers = "";
    strNumbers = "0123456789";
    for(xs=1;xs<=lenstr1FULL;++xs)
    {
		symb1 = substr(str1FULL, xs, 1);
		posNumbersSymb = match(strNumbers, symb1);
		if(posNumbersSymb!=0) {strOnlyNumbers = strOnlyNumbers symb1;}
	}
    return strOnlyNumbers;
 } {
	posDlit = match($0, "-"); 
	posCALL = match($0, ",CALL"); 
	LenDlit = posCALL - posDlit-1; 
	dlit = substr($0, posDlit+1, LenDlit); #длительность вызова (для 8.2 1/10000 секунд, для 8.3 1/1000000 секунд)
	
	#strPosCALL = substr($0, 1, posCALL); 
	#print dlit " : " strPosCALL;
	
	# + Get CpuTime
	posCpuTime = match($0, "CpuTime=");
	strCpuTime1 = substr($0, posCpuTime);
	posEndCpuTime = match(strCpuTime1, ",");
	if(posEndCpuTime==0) {CpuTime = substr(strCpuTime1, 1);}
	else {CpuTime = substr(strCpuTime1, 1, posEndCpuTime);}
	gsub("CpuTime=", "", CpuTime);
	CpuTime = OnlyNumbers(CpuTime);
	#gsub('\r', "", CpuTime); #Не работает.
	#gsub('$', "", CpuTime); #Не работает.
	#gsub('\>', "", CpuTime); #Не работает.
	# - Get CpuTime
	
	posFileName = match($0, "[0-9]+.log");
	FileNameMore = substr($0, posFileName, 8);
	HH = substr(FileNameMore, 7); # часы
	posLogMMSS = match($0, "log:[0-9][0-9]:[0-9][0-9]");
	MMSS = substr($0, posLogMMSS, 9);
	gsub("log:", "", MMSS);
	MM = substr(MMSS, 4, 2);
	#HHMMSS = HH ":" MMSS; #Часы:Минуты:Секунды
	HHMM = HH ":" MM; #Часы:Минуты
	Usr = "Usr= ,"; # пользователь
	posUsr = match($0, ",Usr=");
	if(posUsr>0)
	{
		strUsrMore = substr($0, posUsr+1);
		posEndUsr = match(strUsrMore, ",");
		Usr = substr(strUsrMore, 1, posEndUsr-1);
	}
	
	ToAdd = 0; # определяет, выполнять ли проверку в массиве и добавление, т.е. пропускать строку или нет
	
	posFunc = match($0, ",Func=");
	if(posFunc!=0) # у регламентных заданий так
	{	
		ToAdd = 1;
		posBase = match($0, "p:processName=");
		LenBase = posFunc - posBase;
		pBase = substr($0, posBase, LenBase); 
		gsub("p:processName", "Base", pBase); 
		posMemory = match($0, ",Memory=");
		LenMethod = posMemory - posFunc;
		Method = substr($0, posFunc+1, LenMethod);
		KeyStr = pBase " :: " Method;	
	}
	if(posFunc==0) # у пользовательских вызовов так
	{
		posContext = match($0, ",Context=");
		if(posContext!=0)
		{
			ToAdd = 1;
			posBase = match($0, "p:processName=");
			postClientID = match($0, ",t:clientID=");
			LenBase = postClientID - posBase;
			pBase = substr($0, posBase, LenBase);
			gsub("p:processName", "Base", pBase);
			strContexMore = substr($0, posContext+1);
			posEndContext = match(strContexMore, ",");
			Context = substr(strContexMore, 1, posEndContext); 
			KeyStr = pBase " :: " Context;
		}
	}
	
	if(ToAdd==1)
	{
		# определяем есть ли уже этот контекст в массиве
		isexist = 0;
			for(i in arrContext)
			{
				# если есть, то прибавляем только длительность
				if(arrContext[i]==KeyStr) 
				{
					if(arrCpu[i]<CpuTime)
					{
						arrDuration[i]=dlit;
						arrHHMMSS[i]=HHMM;
						arrUsr[i]=Usr;
						arrCpu[i]=CpuTime;
					} 
					isexist = 1; 
					break;
				} 
			}
			if (isexist == 0) # если отсутствует, то добавляем новый элемент массива
			{
				y+=1;
				arrContext[y] = KeyStr;
				arrDuration[y] = dlit;
				arrHHMMSS[y]=HHMM;
				arrUsr[y]=Usr;
				arrCpu[y]=CpuTime;
			}
	}	
} END {
	for (i in arrContext) 
	{
		print arrCpu[i] ";; CpuTime (sec): " arrCpu[i]/1000000 ";; CpuTime (min): " (arrCpu[i]/1000000)/60 ";; Time: " arrHHMMSS[i] ";; Duration (sec): " arrDuration[i]/1000000 ";; Duration(min): " (arrDuration[i]/1000000)/60 ";; User: " arrUsr[i] ";; " arrContext[i]
	}
}' | sort -rhb -k 1 | head -n 100


