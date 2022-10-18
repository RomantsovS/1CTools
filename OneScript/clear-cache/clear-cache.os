#Использовать logos

Перем Лог;

Функция Инициализировать()
	
	МассивИсключений = Новый Массив;
	МассивИсключений.Добавить("ExtCompT");

	КаталогиКэша = Новый Массив;
	
	КаталогиКэша.Добавить("%USERPROFILE%\AppData\Roaming\1C\1Cv8");
	КаталогиКэша.Добавить("%USERPROFILE%\AppData\Roaming\1C\1Cv82");
	
	КаталогиКэша.Добавить("%USERPROFILE%\AppData\Local\1C\1Cv8");
	КаталогиКэша.Добавить("%USERPROFILE%\AppData\Local\1C\1Cv82");

	ОчиститьКэш(КаталогиКэша, МассивИсключений);

КонецФункции

// Перемещаят найденные по маскам файлы в каталог резервных копий.
//
// Параметры:
//  КаталогиКэша 	 - Массив - Пути к каталогам кэша для очистки;
//  МассивИсключений - Массив - Имена каталогов, пропускаемых при очистке.
//
Процедура ОчиститьКэш(КаталогиКэша, МассивИсключений)
 	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИмяПапкиПользователя = ПолучитьПеременнуюСреды("USERPROFILE");

	Лог.Отладка(ИмяПапкиПользователя);

	Для Каждого КаталогКэша Из КаталогиКэша Цикл
		
		Путь = СтрЗаменить(КаталогКэша, "%USERPROFILE%", ИмяПапкиПользователя);
		
		Лог.Информация("------------------------------------------------------------");
		Лог.Информация(СтрШаблон(НСтр("ru = 'Обработка каталога %1.'"), Путь));
		Лог.Информация("------------------------------------------------------------");

		КаталогОбъект = Новый Файл(Путь);
		Если НЕ КаталогОбъект.Существует() Тогда
			Лог.Ошибка(НСтр("ru = 'Каталог не найден.'"));
			Продолжить;
		КонецЕсли;

		МассивФайлов = НайтиФайлы(Путь, "*", Ложь); 
		Для Каждого НайденныйФайл Из МассивФайлов Цикл
			Если НайденныйФайл.ЭтоКаталог() 
			   И МассивИсключений.Найти(НайденныйФайл.Имя) = Неопределено Тогда
				Попытка
					УдалитьФайлы(НайденныйФайл.ПолноеИмя);
				Исключение
					Лог.Ошибка(СтрШаблон(НСтр("ru = 'Не удалось удалить каталог %1:
						|%2'"), НайденныйФайл.Имя, ОписаниеОшибки()));
					Продолжить;
				КонецПопытки;
			КонецЕсли;
		КонецЦикла;
			
	КонецЦикла;
	
КонецПроцедуры

Лог = Логирование.ПолучитьЛог("oscript.app.cleaner");
Лог.УстановитьУровень(УровниЛога.Отладка);
Инициализировать();