#Использовать logos
#Использовать v8runner

Перем Лог; // Лог
Перем ИнтервалыОжидания; // Интервалы ожидания

//////////////////////////////////////////////////////////////////////////////////////
// Инициализация

// Инициализация параметров
Процедура Инициализировать()
	
	ИнтервалыОжидания = Новый Структура();
	// Максимальный интервал ожидания завершения сеансов пользователей.
	ИнтервалыОжидания.Вставить("ЗавершениеРаботыПользователей", 120);
	// Максимальный интервал ожидания завершения сеанса файловой информационной базы.
	ИнтервалыОжидания.Вставить("ЗавершениеСеансовФайловойИБ", 60);
	// Интервал ожидания завершения сеанса клиент-серверной информационной базы.
	ИнтервалыОжидания.Вставить("ЗавершениеСеансовСервернойИБ", 2);
	// Интервал ожидания от установки времени до начала блокировки.
	ИнтервалыОжидания.Вставить("ОжиданиеУстановкиБлокировкиСеансов", 300);
	
	ПараметрыПодключения = ПолучитьПараметрыПодключения(1, , "hm-1c-dev", "1740", "itilium_test", Истина, , ,
			"tcp://DB01/ERP", "romantsov_s", "");
	ОбновитьИнформационнуюБазу(ПараметрыПодключения, Истина, Истина, Истина);
	
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////
// Получение параметров конфигурации

///////////////////////////////////////////////////////////////////////////////
// Обновление инфорационной базы

// Получает параметры подключения к информационной базе.
//
// Возвращаемое значение:
//  Структура, Неопределено - Параметры подключения к информационной базе, неопределено в случае ошибки.
//
Функция ПолучитьПараметрыПодключения()
	
	Лог.УстановитьУровень(УровниЛога.Отладка);
	Логирование.ПолучитьЛог("oscript.lib.v8runner").УстановитьУровень(Лог.Уровень());
	
	ПараметрыПодключения = Новый Структура();
	
	ПараметрыПодключения.Вставить("ВариантРаботыИнформационнойБазы", 1);
	ПараметрыПодключения.Вставить("КаталогИнформационнойБазы", "");
	ПараметрыПодключения.Вставить("ИмяСервера1СПредприятия", "hm-1c-dev");
	ПараметрыПодключения.Вставить("ПортАгентаСервера", "1740");
	ПараметрыПодключения.Вставить("ИмяИнформационнойБазыНаСервере1СПредприятия", "itilium_test");
	
	ПараметрыПодключения.Вставить("АутентификацияОперационнойСистемы", Истина);
	ПараметрыПодключения.Вставить("ИмяПользователя", "");
	ПараметрыПодключения.Вставить("ПарольПользователя", "");
	
	ПараметрыПодключения.Вставить("ВерсияПлатформы", "8.3.18.1616");
	
	МассивХранилищ = Новый Массив;
	
	СтруктураХранилища = Новый Структура;
	СтруктураХранилища.Вставить("ИмяРасширения", "СберЛогистика");
	СтруктураХранилища.Вставить("ПутьКХранилищу", "tcp://hm-1c-dev/ITIL/SBL_ext");
	СтруктураХранилища.Вставить("ПользовательХранилища", "itilium_test");
	СтруктураХранилища.Вставить("ПарольХранилища", "");
	МассивХранилищ.Вставить(СтруктураХранилища);

	ПараметрыПодключения.Вставить("МассивХранилищ", МассивХранилищ);

	ПараметрыПодключения.Вставить("ВыполнитьОтложенныеОбработчики", Ложь);
	ПараметрыПодключения.Вставить("БлокироватьСоединенияИБ", Истина);
	ПараметрыПодключения.Вставить("ВыполнятьСжатиеТаблицИБ", Ложь);
	ПараметрыПодключения.Вставить("ВыполнитьОтложенныеОбработчики", Ложь);
	
	РезультатВыполнения = ПроверитьКорректностьПараметровПодключения(ПараметрыПодключения);
	Если Не РезультатВыполнения Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПараметрыПодключения;
	
КонецФункции

// Обновляет информационную базу.
//
// Параметры:
//  ПараметрыПодключения	    	  - Структура - см. в ПолучитьПараметрыПодключения();
//
// Возвращаемое значение:
//  Булево - Признак успешного выполнения.
//
Функция ОбновитьИнформационнуюБазу(ПараметрыПодключения)
	
	
	Если ПараметрыПодключения.ВыполнитьОтложенныеОбработчики Тогда
		РезультатВыполнения = ВыполнитьОтложенныеОбработчикиОбновления(ПараметрыПодключения);
	КонецЕсли;
	
	Если РезультатВыполнения Тогда
		Если ПараметрыПодключения.БлокироватьСоединенияИБ Тогда
			РезультатВыполнения = УстановитьБлокировкуСоединений(ПараметрыПодключения);
		КонецЕсли;
	КонецЕсли;
	
	Если РезультатВыполнения И ПараметрыПодключения.ВыполнитьОбновлениеИзХранилища Тогда
		РезультатВыполнения = ОбновитьКонфигурациюИзХранилища(ПараметрыПодключения);
	КонецЕсли;
	
	Если РезультатВыполнения Тогда
		РезультатВыполнения = ВыполнитьОбновлениеКонфигурацииИнформационнойБазы(ПараметрыПодключения);
	КонецЕсли;
	
	Если РезультатВыполнения И ПараметрыПодключения.ВыполнятьСжатиеТаблицИБ Тогда
		РезультатВыполнения = ВыполнитьТестированиеИИсправление(ПараметрыПодключения);
	КонецЕсли;
	
	Если РезультатВыполнения Тогда
		РезультатВыполнения = ПринятьОбновленияВИнформационнойБазе(ПараметрыПодключения);
	КонецЕсли;
	
	Если ПараметрыПодключения.БлокироватьСоединенияИБ Тогда
		РазрешитьПодключение(ПараметрыПодключения);
	КонецЕсли;
	
	Если РезультатВыполнения И ПараметрыПодключения.ВыполнитьОтложенныеОбработчики Тогда
		РезультатВыполнения = ВыполнитьОтложенныеОбработчикиОбновления(ПараметрыПодключения, Истина);
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

// Осуществляет проверку корректности заполнения параметров подключения
//
// Параметры:
//  ПараметрыПодключения - Структура - см. в ПолучитьПараметрыПодключения().
//
// Возвращаемое значение:
//  Булево - Признак успешного выполнения.
//
Функция ПроверитьКорректностьПараметровПодключения(ПараметрыПодключения)
	
	Лог.Информация(НСтр("ru = 'Проверка корректности параметров подключения.'"));
	
	ФайловыйВариантРаботы = ПараметрыПодключения.ВариантРаботыИнформационнойБазы = 0;
	Если ФайловыйВариантРаботы Тогда
		Если ПустаяСтрока(ПараметрыПодключения.КаталогИнформационнойБазы) Тогда
			Лог.Ошибка(НСтр("ru = 'Не задано месторасположение каталога информационной базы.'"));
			Возврат Ложь;
		КонецЕсли;
	Иначе
		Если ПустаяСтрока(ПараметрыПодключения.ИмяСервера1СПредприятия) 
			Или ПустаяСтрока(ПараметрыПодключения.ИмяИнформационнойБазыНаСервере1СПредприятия) Тогда
			ТекстОшибки = НСтр("ru = 'Не заданы обязательные параметры подключения: ""Имя сервера"";
			| ""Имя ИБ на сервере"".'");
			Лог.Ошибка(ТекстОшибки);
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Лог.Отладка(НСтр("ru = 'Проверка корректности параметров подключения завершена.'"));
	
	Возврат Истина;
	
КонецФункции

// Завершает работу пользователей и устанавливает запрет на подключение новых соединений.
//
// Параметры:
//  ПараметрыПодключения - Структура - см. в ПолучитьПараметрыПодключения().
//
// Возвращаемое значение:
//  Булево - Признак успешного выполнения.
//
Функция УстановитьБлокировкуСоединений(ПараметрыПодключения)
	
	Лог.Информация(НСтр("ru = 'Завершение работы пользователей и установка запрета на подключение новых соединений.'"));
	
	// Получение параметров информационной базы
	Соединение = УстановитьВнешнееСоединениеСБазой(ПараметрыПодключения);
	
	Если Соединение = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Лог.Отладка(СтрШаблон("%1 Устанавливаем блокировку соединений", ТекущаяДата()));
		
		//Соединение.СоединенияИБ.УстановитьБлокировкуСоединений(НСтр("ru = 'Обновление, держитесь...'"), "ПакетноеОбновлениеКонфигурацииИБ");
		Блокировка = Соединение.NewObject("БлокировкаСеансов");
		Блокировка.КодРазрешения = "ПакетноеОбновлениеКонфигурацииИБ";
		
		Если Соединение.СоединенияИБ.КоличествоСеансовИнформационнойБазы(Ложь) <= 1 Тогда
			ОжиданиеУстановкиБлокировкиСеансов = 0;
		Иначе
			ОжиданиеУстановкиБлокировкиСеансов = ИнтервалыОжидания.ОжиданиеУстановкиБлокировкиСеансов;
		КонецЕсли;
		
		Блокировка.Начало = ТекущаяДата() + ОжиданиеУстановкиБлокировкиСеансов;
		//Блокировка.Конец          = ОкончаниеДействияБлокировки;
		Блокировка.Сообщение = Соединение.СоединенияИБ.СформироватьСообщениеБлокировки(НСтр("ru = 'Обновление, держитесь...'"), "");
		Блокировка.Установлена = Истина;
		
		Соединение.УстановитьБлокировкуСеансов(Блокировка);
		
		Интервал = Соединение.СоединенияИБ.ПараметрыБлокировкиСеансов().ИнтервалОжиданияЗавершенияРаботыПользователей * 1000;
		ДатаСтарта = Соединение.СоединенияИБ.ПараметрыБлокировкиСеансов().Начало;
		
		Лог.Отладка(СтрШаблон("Установили блокировку сеансов. начало %1", ДатаСтарта));
		
		Если Интервал > ИнтервалыОжидания.ЗавершениеРаботыПользователей Тогда
			Интервал = ИнтервалыОжидания.ЗавершениеРаботыПользователей;
		КонецЕсли;
		
		Лог.Отладка(СтрШаблон(НСтр("ru = 'Параметры блокировки сеансов:
					|	Интервал ожидания завершения работы пользователей - %1 сек
					|	Дата старта - %2'"), Интервал, ДатаСтарта));
		
		Если Соединение.ЗначениеЗаполнено(ДатаСтарта) Тогда
			
			Пока ТекущаяДата() <= ДатаСтарта Цикл //ждём начало блокировки
				Приостановить(15 * 1000); // Ждем 15 секунд до следующей проверки.
			КонецЦикла;
			
			Если НЕ Соединение.СоединенияИБ.УстановленаБлокировкаСоединений() Тогда
				Приостановить(5 * 1000); //на всякий случай еще 5 секунд подождём
			КонецЕсли;
			
			Лог.Отладка(СтрШаблон("%1 Установили блокировку соединений", ТекущаяДата()));
			
			Пока ТекущаяДата() - Интервал <= ДатаСтарта Цикл
				
				Если НЕ Соединение.СоединенияИБ.УстановленаБлокировкаСоединений()
					ИЛИ Соединение.СоединенияИБ.КоличествоСеансовИнформационнойБазы(Ложь) <= 1 Тогда
					Прервать;
				КонецЕсли;
				
				Лог.Отладка(СтрШаблон("%1 Ожидаем завершение активных сеансов %2", ТекущаяДата(), Соединение.СоединенияИБ.КоличествоСеансовИнформационнойБазы(Ложь)));
				Приостановить(15 * 1000); // Ждем 15 секунд до следующей проверки.
				
			КонецЦикла;
			
			Лог.Отладка(СтрШаблон(НСтр("ru = 'Задержка: %1 сек'"), ТекущаяДата() - ДатаСтарта));
			
		КонецЕсли;
		
		Если НЕ Соединение.СоединенияИБ.УстановленаБлокировкаСоединений() Тогда
			Лог.Ошибка(НСтр("ru = 'Попытка завершения работы пользователей завершилась безуспешно: отменена блокировка ИБ.'"));
			Соединение = Неопределено;
			ОжидатьЗавершения(ПараметрыПодключения);
			Возврат Ложь;
		КонецЕсли;
		
		Если Соединение.СоединенияИБ.КоличествоСеансовИнформационнойБазы(Ложь) <= 1 Тогда
			Лог.Отладка(НСтр("ru = 'Установка запрета на подключение новых соединений выполнена.
					|Все пользователи завершили работу.'"));
			Соединение = Неопределено;
			ОжидатьЗавершения(ПараметрыПодключения);
			Возврат Истина;
		КонецЕсли;
		
		Лог.Отладка(НСтр("ru = 'Принудительное прерывание соединений пользователей.'"));
		
		// после начала блокировки сеансы всех пользователей должны быть отключены
		// если этого не произошло пробуем принудительно прервать соединение.
		ПараметрыАдминистрирования = Соединение.СтандартныеПодсистемыСервер.ПараметрыАдминистрирования();
		ПараметрыАдминистрирования.ИмяАдминистратораИнформационнойБазы = "";
		ПараметрыАдминистрирования.ПарольАдминистратораИнформационнойБазы = "";
		ПараметрыАдминистрирования.ИмяАдминистратораКластера = "";
		ПараметрыАдминистрирования.ПарольАдминистратораКластера = "";
		ПараметрыАдминистрирования.ПортАгентаСервера = ПараметрыПодключения.ПортАгентаСервера;
		
		Лог.Отладка(СтрШаблон("Параметры администрирования: ""%1"", ""%2"", ""%3""", ПараметрыАдминистрирования.ПарольАдминистратораИнформационнойБазы,
				ПараметрыАдминистрирования.ПарольАдминистратораКластера, ПараметрыАдминистрирования.ПортАгентаСервера));
		
		Соединение.СоединенияИБКлиентСервер.УдалитьВсеСеансыКромеТекущего(ПараметрыАдминистрирования);
		
		Если Соединение.СоединенияИБ.КоличествоСеансовИнформационнойБазы(Ложь) > 1 Тогда
			Соединение.СоединенияИБ.РазрешитьРаботуПользователей();
			Лог.Ошибка(Соединение.СоединенияИБ.СообщениеОНеотключенныхСеансах());
			Соединение = Неопределено;
			ОжидатьЗавершения(ПараметрыПодключения);
			Возврат Ложь;
		КонецЕсли;
		
	Исключение
		Лог.Ошибка(СтрШаблон(НСтр("ru = 'Ошибка при установке запрета на подключение новых соединений.
					|%1'"), ИнформацияОбОшибке()));
		Соединение = Неопределено;
		ОжидатьЗавершения(ПараметрыПодключения);
		Возврат Ложь;
	КонецПопытки;
	
	Соединение = Неопределено;
	ОжидатьЗавершения(ПараметрыПодключения);
	
	Лог.Отладка(НСтр("ru = 'Установка запрета на подключение новых соединений выполнена.
			|Работа всех пользователей прервана.'"));
	
	Возврат Истина;
	
КонецФункции

// Устанавливает внешнее соединение с информационной базой по переданным параметрам подключения и возвращает указатель
// на это соединение.
//
// Параметры:
//  ПараметрыПодключения - Структура - Параметры подключения к информационной базе (см. в ОбновитьИнформационнуюБазу()).
//
// Возвращаемое значение:
//  COMОбъект, Неопределено - указатель на COM-объект соединения или Неопределено в случае ошибки;
//
Функция УстановитьВнешнееСоединениеСБазой(Знач ПараметрыПодключения)
	
	ИмяCOMСоединителя = "V" + ПараметрыПодключения.ВерсияПлатформы + ".COMConnector";
	
	Лог.Отладка(СтрШаблон(Нстр("ru = 'Создаём COMОбъект %1'"), ИмяCOMСоединителя));
	
	Попытка
		COMОбъект = Новый COMОбъект(ИмяCOMСоединителя);
	Исключение
		Лог.Ошибка(СтрШаблон(НСтр("ru = 'Не удалось создать COMОбъект:
					|%1'"), ИнформацияОбОшибке()));
		Возврат Неопределено;
	КонецПопытки;
	
	Лог.Отладка(СтрШаблон("Comобъект %1 создан успешно", ИмяCOMСоединителя));
	
	ФайловыйВариантРаботы = ПараметрыПодключения.ВариантРаботыИнформационнойБазы = 0;
	
	// Формирование строки соединения.
	ШаблонСтрокиСоединения = "[СтрокаБазы][СтрокаАутентификации];UC=ПакетноеОбновлениеКонфигурацииИБ";
	
	Если ФайловыйВариантРаботы Тогда
		СтрокаБазы = "File = ""&КаталогИнформационнойБазы""";
		СтрокаБазы = СтрЗаменить(СтрокаБазы, "&КаталогИнформационнойБазы", ПараметрыПодключения.КаталогИнформационнойБазы);
	Иначе
		СтрокаБазы = "Srvr = ""&ИмяСервера1СПредприятия""; Ref = ""&ИмяИнформационнойБазыНаСервере1СПредприятия""";
		СтрокаБазы = СтрЗаменить(СтрокаБазы, "&ИмяСервера1СПредприятия", ПараметрыПодключения.ИмяСервера1СПредприятия);
		СтрокаБазы = СтрЗаменить(СтрокаБазы, "&ИмяИнформационнойБазыНаСервере1СПредприятия", ПараметрыПодключения.ИмяИнформационнойБазыНаСервере1СПредприятия);
	КонецЕсли;
	
	Если ПараметрыПодключения.АутентификацияОперационнойСистемы Тогда
		СтрокаАутентификации = "";
	Иначе
		
		Если СтрНайти(ПараметрыПодключения.ИмяПользователя, """") Тогда
			ПараметрыПодключения.ИмяПользователя = СтрЗаменить(ПараметрыПодключения.ИмяПользователя, """", """""");
		КонецЕсли;
		
		Если СтрНайти(ПараметрыПодключения.ПарольПользователя, """") Тогда
			ПараметрыПодключения.ПарольПользователя = СтрЗаменить(ПараметрыПодключения.ПарольПользователя, """", """""");
		КонецЕсли;
		
		СтрокаАутентификации = "; Usr = ""&ИмяПользователя""; Pwd = ""&ПарольПользователя""";
		СтрокаАутентификации = СтрЗаменить(СтрокаАутентификации, "&ИмяПользователя", ПараметрыПодключения.ИмяПользователя);
		СтрокаАутентификации = СтрЗаменить(СтрокаАутентификации, "&ПарольПользователя", ПараметрыПодключения.ПарольПользователя);
	КонецЕсли;
	
	СтрокаСоединения = СтрЗаменить(ШаблонСтрокиСоединения, "[СтрокаБазы]", СтрокаБазы);
	СтрокаСоединения = СтрЗаменить(СтрокаСоединения, "[СтрокаАутентификации]", СтрокаАутентификации);
	
	Лог.Информация(СтрШаблон("СтрокаСоединения: %1", СтрокаСоединения));
	
	Попытка
		Соединение = COMОбъект.Connect(СтрокаСоединения);
	Исключение
		Лог.Ошибка(СтрШаблон(НСтр("ru = 'Не удалось подключится к другой программе:
					|%1'"), ИнформацияОбОшибке()));
		Возврат Неопределено;
	КонецПопытки;
	
	Лог.Отладка("Установили соединение");
	
	Возврат Соединение;
	
КонецФункции

// Выполняет все процедуры отложенного обновления информационной базы
//
// Параметры:
//  ПараметрыПодключения - Структура - Параметры подключения к информационной базе (см. в ПолучитьПараметрыПодключения()).
//
// Возвращаемое значение:
//  Булево - Признак успешного выполнения.
//
Функция ВыполнитьОтложенныеОбработчикиОбновления(ПараметрыПодключения, ФоновымЗаданием = Ложь)
	
	Лог.Информация(НСтр("ru = 'Выполнение отложенных обработчиков обновления.'"));
	
	Соединение = УстановитьВнешнееСоединениеСБазой(ПараметрыПодключения);
	Если Соединение = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		СведенияОбОбновлении = Соединение.ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
		
		Лог.Отладка(СтрШаблон("СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления: %1", СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления));
		
		Если ФоновымЗаданием Тогда
			Попытка
				Соединение.НачатьТранзакцию();
				
				Блокировка = Соединение.NewObject("БлокировкаДанных");
				ЭлементБлокировки = Блокировка.Добавить("Константа.СведенияОбОбновленииИБ");
				Блокировка.Заблокировать();
				
				СведенияОбОбновлении = Соединение.ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
				СведенияОбОбновлении.УправлениеОтложеннымОбновлением.Вставить("ФорсироватьОбновление");
				
				Соединение.ОбновлениеИнформационнойБазыСлужебный.ЗаписатьСведенияОбОбновленииИнформационнойБазы(СведенияОбОбновлении);
				
				Соединение.ЗафиксироватьТранзакцию();
				
				Лог.Отладка(НСтр("ru = 'Установили форсированное обновление.'"));
			Исключение
				Лог.Ошибка(СтрШаблон(НСтр("ru = 'Ошибка установки форсированного обновления %1'"), ИнформацияОбОшибке()));
				
				Возврат Ложь;
			КонецПопытки;
			
			Соединение.ФоновыеЗадания.Выполнить("ОбновлениеИнформационнойБазыСлужебный.ВыполнитьОтложенноеОбновление");
			
			Лог.Отладка(НСтр("ru = 'Выполнение отложенных обработчиков обновления запущено фоновым заданием.'"));
		Иначе
			Лог.Отладка(НСтр("ru = 'Запускаем ВыполнитьОтложенноеОбновлениеСейчас.'"));
			
			Соединение.ОбновлениеИнформационнойБазыСлужебный.ВыполнитьОтложенноеОбновлениеСейчас();
			
			Лог.Отладка(НСтр("ru = 'Выполнение отложенных обработчиков обновления завершено.'"));
		КонецЕсли;
	Исключение
		Лог.Ошибка(СтрШаблон(НСтр("ru = 'Ошибка при выполнении отложенных обработчиков обновления.
					|%1'"), ИнформацияОбОшибке()));
		
		Соединение = Неопределено;
		ОжидатьЗавершения(ПараметрыПодключения);
		
		Возврат Истина;
	КонецПопытки;
	
	Соединение = Неопределено;
	ОжидатьЗавершения(ПараметрыПодключения);
	
	Возврат Истина;
	
КонецФункции

// Обновляет конфигурацию из хранилища
//
// Параметры:
//  ПараметрыПодключения 			- Структура - Параметры подключения к информационной базе (см. в ПолучитьПараметрыПодключения());
//  ВерсияДляОбновления  			- Строка	- Версия для обновления.
//
// Возвращаемое значение:
//  Булево - Признак успешного выполнения.
//
Функция ОбновитьКонфигурациюИзХранилища(ПараметрыПодключения, ВерсияДляОбновления = 0)
	
	Лог.Информация(НСтр("ru = 'Обновление конфигурации из хранилища.'"));
	
	УправлениеКонфигуратором = УстановитьУправлениеКонфигуратором(ПараметрыПодключения);
	
	Попытка
		УправлениеКонфигуратором.ЗагрузитьКонфигурациюИзХранилища(ПараметрыПодключения.ПутьКХранилищу,
			ПараметрыПодключения.ПользовательХранилища, ПараметрыПодключения.ПарольХранилища, ВерсияДляОбновления);
	Исключение
		Лог.Ошибка(СтрШаблон(НСтр("ru = 'Ошибка при загрузке файла обновления в информационную базу.
					|%1'"), УправлениеКонфигуратором.ВыводКоманды()));
		Возврат Ложь;
	КонецПопытки;
	
	Лог.Отладка(НСтр("ru = 'Обновление конфигурации из хранилища завершено.'"));
	
	Возврат Истина;
	
КонецФункции

// Выполняет обновление конфигурации информационной базы
//
// Параметры:
//  ПараметрыПодключения - Структура - Параметры подключения к информационной базе (см. в ПолучитьПараметрыПодключения()).
//
// Возвращаемое значение:
//  Булево - Признак успешного выполнения.
//
Функция ВыполнитьОбновлениеКонфигурацииИнформационнойБазы(ПараметрыПодключения)
	
	Лог.Информация(НСтр("ru = 'Обновление конфигурации информационной базы.'"));
	
	УправлениеКонфигуратором = УстановитьУправлениеКонфигуратором(ПараметрыПодключения);
	
	ДатаНачала = ТекущаяДата();
	ДатаОкончания = ДатаНачала + 60 * 10;
	
	Лог.Отладка(СтрШаблон("Начало обновления конфигурации ИБ начало: %1, окончание - %2", ДатаНачала, ДатаОкончания));
	
	Пока ТекущаяДата() < ДатаОкончания Цикл
		Попытка
			УправлениеКонфигуратором.ОбновитьКонфигурациюБазыДанных();
		Исключение
			Лог.Ошибка(СтрШаблон(НСтр("ru = '%1 Ошибка при обновлении конфигурации информационной базы.
						|%2'"), ТекущаяДата(), УправлениеКонфигуратором.ВыводКоманды()));
			Продолжить;
		КонецПопытки;
		
		Прервать;
	КонецЦикла;
	
	Лог.Отладка(НСтр("ru = 'Обновление конфигурации информационной базы завершено.'"));
	
	Возврат Истина;
	
КонецФункции

// Выполняет тестирование и исправление
//
// Параметры:
//  ПараметрыПодключения - Структура - Параметры подключения к информационной базе (см. в ПолучитьПараметрыПодключения()).
//
// Возвращаемое значение:
//  Булево - Признак успешного выполнения.
//
Функция ВыполнитьТестированиеИИсправление(ПараметрыПодключения)
	
	Лог.Информация(НСтр("ru = 'Тестирование и исправление информационной базы.'"));
	
	УправлениеКонфигуратором = УстановитьУправлениеКонфигуратором(ПараметрыПодключения);
	ПараметрыЗапуска = УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/IBCheckAndRepair -IBCompression");
	
	Попытка
		УправлениеКонфигуратором.ВыполнитьКоманду(ПараметрыЗапуска);
	Исключение
		Лог.Ошибка(СтрШаблон(НСтр("ru = 'Ошибка при тестировании и исправлении информационной базы.
					|%1'"), УправлениеКонфигуратором.ВыводКоманды()));
		Возврат Ложь;
	КонецПопытки;
	
	Лог.Отладка(НСтр("ru = 'Тестирование и исправление информационной базы завершено.'"));
	
	Возврат Истина;
	
КонецФункции

// Выполняет неинтерактивное обновление данных информационной базы
//
// Параметры:
//  ПараметрыПодключения - Структура - Параметры подключения к информационной базе (см. в ПолучитьПараметрыПодключения()).
//
// Возвращаемое значение:
//  Булево - Признак успешного выполнения.
//
Функция ПринятьОбновленияВИнформационнойБазе(ПараметрыПодключения)
	
	Лог.Информация(НСтр("ru = 'Принятие обновлений в информационной базе.'"));
	
	Соединение = УстановитьВнешнееСоединениеСБазой(ПараметрыПодключения);
	Если Соединение = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Результат = Соединение.ОбновлениеИнформационнойБазы.ВыполнитьОбновлениеИнформационнойБазы(Ложь);
	Исключение
		Лог.Ошибка(СтрШаблон(НСтр("ru = 'Ошибка при принятии изменений в информационной базе.
					|%1'"), ИнформацияОбОшибке()));
		Соединение = Неопределено;
		ОжидатьЗавершения(ПараметрыПодключения);
		Возврат Истина;
	КонецПопытки;
	
	РезультатВыполнения = Ложь;
	
	Если Результат = "Успешно" Тогда
		Лог.Отладка(НСтр("ru = 'Принятие обновлений в информационной базе завершено.'"));
		
		Лог.Отладка(НСтр("ru = 'Запись подтверждения легальности получения обновлений.'"));
		Соединение.ОбновлениеИнформационнойБазыСлужебный.ЗаписатьПодтверждениеЛегальностиПолученияОбновлений();
		Лог.Отладка(НСтр("ru = 'Запись подтверждения легальности получения обновлений завершено.'"));
		
		
		РезультатВыполнения = Истина;
	ИначеЕсли Результат = "НеТребуется" Тогда
		Лог.Отладка(НСтр("ru = 'Принятие обновлений в информационной базе не требуется.'"));
		РезультатВыполнения = Истина;
	Иначе
		Лог.Ошибка(НСтр("ru = 'Ошибка установки монопольного режима. %1'"), Результат);
	КонецЕсли;
	
	Соединение = Неопределено;
	ОжидатьЗавершения(ПараметрыПодключения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

// Разрешает подключение новых соединений.
//
// Параметры:
//  ПараметрыПодключения - Структура - Параметры подключения к информационной базе (см. в ПолучитьПараметрыПодключения()).
//
// Возвращаемое значение:
//  Булево - Признак успешного выполнения.
//
Функция РазрешитьПодключение(ПараметрыПодключения)
	
	Лог.Информация(НСтр("ru = 'Разрешение подключений новых соединений.'"));
	
	// Получение параметров информационной базы
	Соединение = УстановитьВнешнееСоединениеСБазой(ПараметрыПодключения);
	Если Соединение = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Соединение.СоединенияИБ.РазрешитьРаботуПользователей();
	Исключение
		Лог.Ошибка(СтрШаблон(НСтр("ru = 'Ошибка при разрешении подключений новых соединений.
					|%1'"), ИнформацияОбОшибке()));
		Соединение = Неопределено;
		ОжидатьЗавершения(ПараметрыПодключения);
		Возврат Истина;
	КонецПопытки;
	
	Соединение = Неопределено;
	ОжидатьЗавершения(ПараметрыПодключения);
	
	Лог.Отладка(НСтр("ru = 'Разрешение подключений новых соединений завершено.'"));
	
	Возврат Истина;
	
КонецФункции

//////////////////////////////////////////////////////////////////////////////////////
// Служебные процедуры и функции

// Проверяет наличия каталога и в случае его отсутствия создает новый.
//
// Параметры:
//  Каталог - Строка - Путь к каталогу, существование которого нужно проверить.
//
// Возвращаемое значение:
//  Булево - признак существования каталога.
//
Функция ОбеспечитьКаталог(Знач Каталог)
	
	Файл = Новый Файл(Каталог);
	Если Не Файл.Существует() Тогда
		Попытка
			СоздатьКаталог(Каталог);
		Исключение
			Лог.Ошибка(СтрШаблон(НСтр("ru = 'Не удалось создать каталог %1.
						|%2'"), Каталог, ИнформацияОбОшибке()));
			Возврат Ложь;
		КонецПопытки;
		
		Если Не Файл.Существует() Тогда
			Лог.Ошибка(СтрШаблон(НСтр("ru = 'Не удалось создать каталог %1.'"), Каталог));
			Возврат Ложь;
		КонецЕсли
		
	ИначеЕсли Не Файл.ЭтоКаталог() Тогда
		Лог.Ошибка(СтрШаблон(НСтр("ru = 'Каталог %1 не является каталогом.'"), Каталог));
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Ожидает завершения подключений к информационной базе.
//
// Параметры:
//  ПараметрыПодключения - Структура - Параметры подключения к информационной базе (см. в ОбновитьИнформационнуюБазу()).
//
Процедура ОжидатьЗавершения(Знач ПараметрыПодключения)
	
	// Несмотря на установку "Соединение = Неопределено;", на медленных компьютерах Com соединения не успевает
	// отваливаться до вызова следующей функции. Это приводит к невозможности установить монопольный доступ и ошибке.
	// Для обхода ошибки реализована задержка.
	
	ФайловыйВариантРаботы = ПараметрыПодключения.ВариантРаботыИнформационнойБазы = 0;
	
	Если ФайловыйВариантРаботы Тогда
		
		ФайлНаличияСоединений = Новый Файл(ОбъединитьПути(ПараметрыПодключения.КаталогИнформационнойБазы, "1Cv8tmp.1CD"));
		Если Не ФайлНаличияСоединений.Существует() Тогда
			Возврат;
		КонецЕсли;
		
		ДатаСтарта = ТекущаяДата();
		Интервал = ИнтервалыОжидания.ЗавершениеСеансовФайловойИБ;
		
		Пока ТекущаяДата() - Интервал <= ДатаСтарта Цикл
			Если Не ФайлНаличияСоединений.Существует() Тогда
				Прервать;
			КонецЕсли;
			Приостановить(100); // Ждем 0.1 секунд до следующей проверки.
		КонецЦикла;
		
	Иначе
		
		ДатаСтарта = ТекущаяДата();
		Интервал = ИнтервалыОжидания.ЗавершениеСеансовСервернойИБ;
		
		Приостановить(1000 * Интервал);
		
	КонецЕсли;
	
	Лог.Отладка(СтрШаблон(НСтр("ru = 'Задержка: %1 сек'"), ТекущаяДата() - ДатаСтарта));
	
КонецПроцедуры

// Устанавливает контекст библиотеки v8runner и возвращиет указатель на объект.
//
// Параметры:
//  ПараметрыПодключения - Структура - Параметры подключения к информационной базе (см. в ОбновитьИнформационнуюБазу()).
//
// Возвращаемое значение:
//  УправлениеКонфигуратором - объект библиотеки v8runner;
//
Функция УстановитьУправлениеКонфигуратором(Знач ПараметрыПодключения)
	
	УправлениеКонфигуратором = Новый УправлениеКонфигуратором();
	
	ФайловыйВариантРаботы = ПараметрыПодключения.ВариантРаботыИнформационнойБазы = 0;
	
	Если ФайловыйВариантРаботы Тогда
		СтрокаСоединения = "/F""&КаталогИнформационнойБазы""";
		СтрокаСоединения = СтрЗаменить(СтрокаСоединения, "&КаталогИнформационнойБазы", ПараметрыПодключения.КаталогИнформационнойБазы);
	Иначе
		СтрокаСоединения = "/S""&ИмяСервера1СПредприятия\&ИмяИнформационнойБазыНаСервере1СПредприятия""";
		СтрокаСоединения = СтрЗаменить(СтрокаСоединения, "&ИмяСервера1СПредприятия", ПараметрыПодключения.ИмяСервера1СПредприятия);
		СтрокаСоединения = СтрЗаменить(СтрокаСоединения, "&ИмяИнформационнойБазыНаСервере1СПредприятия", ПараметрыПодключения.ИмяИнформационнойБазыНаСервере1СПредприятия);
	КонецЕсли;
	
	Если ПараметрыПодключения.АутентификацияОперационнойСистемы Тогда
		ПараметрыПодключения.ИмяПользователя = "";
		ПараметрыПодключения.ПарольПользователя = "";
	КонецЕсли;
	
	УправлениеКонфигуратором.УстановитьКонтекст(СтрокаСоединения, ПараметрыПодключения.ИмяПользователя, ПараметрыПодключения.ПарольПользователя);
	УправлениеКонфигуратором.УстановитьКлючРазрешенияЗапуска("ПакетноеОбновлениеКонфигурацииИБ");
	
	//УправлениеКонфигуратором.КаталогСборки(Каталоги.КаталогВременныхФайлов);
	
	Возврат УправлениеКонфигуратором;
	
КонецФункции

Лог = Логирование.ПолучитьЛог("oscript.app.AutoUpdateIB");
Инициализировать();