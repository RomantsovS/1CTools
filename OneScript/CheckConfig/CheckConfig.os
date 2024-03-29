#Использовать logos
#Использовать v8runner

Перем Лог; // лог
Перем ИнтервалыОжидания; // интервалы ожидания

//////////////////////////////////////////////////////////////////////////////////////
// Инициализация

// Инициализация параметров
Процедура Инициализировать()

	ИнтервалыОжидания = Новый Структура();
	ИнтервалыОжидания.Вставить("ЗавершениеРаботыПользователей", 120); // Максимальный интервал ожидания завершения сеансов пользователей. 
	ИнтервалыОжидания.Вставить("ЗавершениеСеансовФайловойИБ", 60); // Максимальный интервал ожидания завершения сеанса файловой информационной базы.
	ИнтервалыОжидания.Вставить("ЗавершениеСеансовСервернойИБ", 2); // Интервал ожидания завершения сеанса клиент-серверной информационной базы.
	ИнтервалыОжидания.Вставить("ОжиданиеУстановкиБлокировкиСеансов", 300); // Интервал ожидания от установки времени до начала блокировки.

	//////////////////////////////////////////////////////////////////////////////////////
	// Пример

	ПараметрыПроверки = "";
	ПараметрыПроверки = ПараметрыПроверки + " -ConfigLogIntegrity";
	ПараметрыПроверки = ПараметрыПроверки + " -IncorrectReferences";
	ПараметрыПроверки = ПараметрыПроверки + " -ThinClient";
	ПараметрыПроверки = ПараметрыПроверки + " -WebClient";
	ПараметрыПроверки = ПараметрыПроверки + " -Server";
	ПараметрыПроверки = ПараметрыПроверки + " -ExternalConnection";
	ПараметрыПроверки = ПараметрыПроверки + " -ExternalConnectionServer";
	ПараметрыПроверки = ПараметрыПроверки + " -ThickClientManagedApplication";
	ПараметрыПроверки = ПараметрыПроверки + " -ThickClientServerManagedApplication";
	ПараметрыПроверки = ПараметрыПроверки + " -ThickClientOrdinaryApplication";
	ПараметрыПроверки = ПараметрыПроверки + " -ThickClientServerOrdinaryApplication";
	//ПараметрыПроверки = ПараметрыПроверки + " -UnreferenceProcedures";
	ПараметрыПроверки = ПараметрыПроверки + " -HandlersExistence";
	ПараметрыПроверки = ПараметрыПроверки + " -EmptyHandlers";
	ПараметрыПроверки = ПараметрыПроверки + " -ExtendedModulesCheck";
	ПараметрыПроверки = ПараметрыПроверки + " -CheckUseSyncronousCalls";
	ПараметрыПроверки = ПараметрыПроверки + " -CheckUseModality";

	ПользовательИБ = "";
	ПарольПользователяИБ = "";
	ПараметрыПодключения = ПолучитьПараметрыПодключения(0,"e:\SPPR\ERP\Bases\SPPR_main","cv8app12:1741", "1740", "ERP-DEV-UPD",
	Ложь, ПользовательИБ, ПарольПользователяИБ, "tcp://DB01/ERP", "Администратор", , "8.3.12",
	"\\rusklimat.ru\app\IT\1C_group\romantsov_s\OneScript\CheckConfig\out.txt", ПараметрыПроверки);
	ОбновитьИнформационнуюБазу(ПараметрыПодключения, Ложь, Ложь);

КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////
// Получение параметров конфигурации

///////////////////////////////////////////////////////////////////////////////
// Обновление инфорационной базы

// Получает параметры подключения к информационной базе.
	// 
	// Параметры:
	//  ВариантРаботыИнформационнойБазы				- Число  - Вариант работы информационной базы: 0 - файловый; 1 - клиент-серверный;
	//  КаталогИнформационнойБазы					- Строка - Каталог информационной базы для файлового режима работы;
	//  ИмяСервера1СПредприятия						- Строка - Имя сервера 1С:Предприятия;
	// ПортАгентаСервера							- Строка
	//  ИмяИнформационнойБазыНаСервере1СПредприятия - Строка - Имя информационной базы на сервере 1С:Предприятия;
	//  АутентификацияОперационнойСистемы			- Булево - Признак аутентификации операционной системы при создании внешнего подключения к информационной базе;
	//  ИмяПользователя								- Строка - Имя пользователя информационной базы;
	//  ПарольПользователя							- Строка - Пароль пользователя информационной базы;
	// ПутьКХранилищу								- Строка
	// ПользовательХранилища						- Строка
	// ПарольХранилища								- Строка
	// ВерсияПлатформы								- Строка - Версия платформы (8.3.12).
	// ПустьКФайлуРезультата						- Строка
	// КлючиПроверкиМодулей							- Строка
	//
	// Возвращаемое значение:
	//  Структура, Неопределено - Параметры подключения к информационной базе, неопределено в случае ошибки.
	//
Функция ПолучитьПараметрыПодключения(ВариантРаботыИнформационнойБазы = 0, КаталогИнформационнойБазы = "", ИмяСервера1СПредприятия = "",
						ПортАгентаСервера = "", ИмяИнформационнойБазыНаСервере1СПредприятия = "", АутентификацияОперационнойСистемы = Ложь,
						ИмяПользователя = "Администратор", ПарольПользователя = "", ПутьКХранилищу = "", ПользовательХранилища = "",
						ПарольХранилища = "", ВерсияПлатформы = "8.3.12", ПустьКФайлуРезультата = "", КлючиПроверкиМодулей = "")

	Лог.Информация("------------------------------------------------------------");
	Лог.Информация(СтрШаблон(НСтр("ru = 'Информационная база %1.'"), 
		?(ВариантРаботыИнформационнойБазы = 0, КаталогИнформационнойБазы, ИмяИнформационнойБазыНаСервере1СПредприятия)));
	Лог.Информация("------------------------------------------------------------");
	
	Лог.УстановитьУровень(УровниЛога.Отладка);
	Логирование.ПолучитьЛог("oscript.lib.v8runner").УстановитьУровень(Лог.Уровень());

	ПараметрыПодключения = Новый Структура();
	
	ПараметрыПодключения.Вставить("ВариантРаботыИнформационнойБазы", 			 ВариантРаботыИнформационнойБазы);
	ПараметрыПодключения.Вставить("КаталогИнформационнойБазы", 					 КаталогИнформационнойБазы);
	ПараметрыПодключения.Вставить("ИмяСервера1СПредприятия", 					 ИмяСервера1СПредприятия);
	ПараметрыПодключения.Вставить("ПортАгентаСервера", 					 		 ПортАгентаСервера);
	ПараметрыПодключения.Вставить("ИмяИнформационнойБазыНаСервере1СПредприятия", ИмяИнформационнойБазыНаСервере1СПредприятия);
	
	ПараметрыПодключения.Вставить("АутентификацияОперационнойСистемы", АутентификацияОперационнойСистемы);
	ПараметрыПодключения.Вставить("ИмяПользователя", 				   ИмяПользователя);
	ПараметрыПодключения.Вставить("ПарольПользователя", 			   ПарольПользователя);
	
	ПараметрыПодключения.Вставить("ВерсияПлатформы", ВерсияПлатформы);
	ПараметрыПодключения.Вставить("ВерсияПлатформыCom", СтрЗаменить(Лев(ВерсияПлатформы, 3), ".", ""));
	
	ПараметрыПодключения.Вставить("ПутьКХранилищу", ПутьКХранилищу);
	ПараметрыПодключения.Вставить("ПользовательХранилища", ПользовательХранилища);
	ПараметрыПодключения.Вставить("ПарольХранилища", ПарольХранилища);

	ПараметрыПодключения.Вставить("ПустьКФайлуРезультата", ПустьКФайлуРезультата);
	ПараметрыПодключения.Вставить("КлючиПроверкиМодулей", КлючиПроверкиМодулей);

	РезультатВыполнения = ПроверитьКорректностьПараметровПодключения(ПараметрыПодключения);
	Если Не РезультатВыполнения Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПараметрыПодключения; 
	
КонецФункции

// Обновляет информационную базу.
	// 
	// Параметры:
	//  ПараметрыПодключения	    	  - Структура - Параметры подключения к информационной базе (см. в ПолучитьПараметрыПодключения()).
	//  БлокироватьСоединенияИБ 		  - Булево	  - Устанавливать блокировку соединений перед обновлением;
	//  ВыполнитьОбновлениеИзХранилища	  - Булево;
	//
	// Возвращаемое значение:
	//  Булево - Признак успешного выполнения.
	// 
Функция ОбновитьИнформационнуюБазу(ПараметрыПодключения, БлокироватьСоединенияИБ = Ложь, ВыполнитьОбновлениеИзХранилища = Ложь)

	Если БлокироватьСоединенияИБ Тогда 	
		РезультатВыполнения = УстановитьБлокировкуСоединений(ПараметрыПодключения);
	Иначе
		РезультатВыполнения = Истина;
	КонецЕсли;

	Если РезультатВыполнения И ВыполнитьОбновлениеИзХранилища Тогда
		РезультатВыполнения = ОбновитьКонфигурациюИзХранилища(ПараметрыПодключения);
	КонецЕсли;

	Если БлокироватьСоединенияИБ Тогда		
		РазрешитьПодключение(ПараметрыПодключения);
	КонецЕсли;

	Если РезультатВыполнения Тогда
		ВыполнитьПроверкуКонфигурации(ПараметрыПодключения);
	КонецЕсли;

	Возврат РезультатВыполнения;
	
КонецФункции	

// Осуществляет проверку корректности заполнения параметров подключения
	// 
	// Параметры:
	//  ПараметрыПодключения - Структура - Параметры подключения к информационной базе (см. в ПолучитьПараметрыПодключения()).
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
		Если ПустаяСтрока(ПараметрыПодключения.ИмяСервера1СПредприятия) Или ПустаяСтрока(ПараметрыПодключения.ИмяИнформационнойБазыНаСервере1СПредприятия) Тогда
			Лог.Ошибка(НСтр("ru = 'Не заданы обязательные параметры подключения: ""Имя сервера""; ""Имя информационной базы на сервере"".'"));
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Лог.Отладка(НСтр("ru = 'Проверка корректности параметров подключения завершена.'"));     
	
	Возврат Истина;
	
КонецФункции	

// Завершает работу пользователей и устанавливает запрет на подключение новых соединений.
	//
	// Параметры:
	//  ПараметрыПодключения - Структура - Параметры подключения к информационной базе (см. в ПолучитьПараметрыПодключения()).
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

		Блокировка = Соединение.NewObject("БлокировкаСеансов");
		Блокировка.КодРазрешения    = "ПакетноеОбновлениеКонфигурацииИБ";
	
		Если Соединение.СоединенияИБ.КоличествоСеансовИнформационнойБазы(Ложь) <= 1 Тогда
			ОжиданиеУстановкиБлокировкиСеансов = 0;
		Иначе
			ОжиданиеУстановкиБлокировкиСеансов = ИнтервалыОжидания.ОжиданиеУстановкиБлокировкиСеансов;
		КонецЕсли;
		
		Блокировка.Начало           = ТекущаяДата() + ОжиданиеУстановкиБлокировкиСеансов;
		//Блокировка.Конец          = ОкончаниеДействияБлокировки;
		Блокировка.Сообщение        = Соединение.СоединенияИБ.СформироватьСообщениеБлокировки(НСтр("ru = 'Обновление, держитесь...'"), ""); 
		Блокировка.Установлена      = Истина;
	
		Соединение.УстановитьБлокировкуСеансов(Блокировка);
		
		Интервал   = Соединение.СоединенияИБ.ПараметрыБлокировкиСеансов().ИнтервалОжиданияЗавершенияРаботыПользователей * 1000;
		ДатаСтарта = Соединение.СоединенияИБ.ПараметрыБлокировкиСеансов().Начало;
		
		Лог.Отладка(СтрШаблон("Установили блокировку сеансов. начало %1", ДатаСтарта));

		Если Интервал > ИнтервалыОжидания.ЗавершениеРаботыПользователей Тогда
			Интервал = ИнтервалыОжидания.ЗавершениеРаботыПользователей;
		КонецЕсли;
			
		Лог.Отладка(СтрШаблон(НСтр("ru = 'Параметры блокировки сеансов:
			|	Интервал ожидания завершения работы пользователей - %1 сек
			|	Дата старта - %2'"), Интервал, ДатаСтарта));
		
		Если Соединение.ЗначениеЗаполнено(ДатаСтарта) Тогда
			
			Пока ТекущаяДата() <= ДатаСтарта Цикл // ждём начало блокировки
				Приостановить(15 * 1000); // Ждем 15 секунд до следующей проверки.
			КонецЦикла;

			Если НЕ Соединение.СоединенияИБ.УстановленаБлокировкаСоединений() Тогда
				Приостановить(5 * 1000); // на всякий случай еще 5 секунд подождём
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
	
		ИмяCOMСоединителя = "V" + ПараметрыПодключения.ВерсияПлатформыCom + ".COMConnector";
	
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
			СтрокаБазы = СтрЗаменить(СтрокаБазы, "&ИмяСервера1СПредприятия",                     ПараметрыПодключения.ИмяСервера1СПредприятия);
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
			СтрокаАутентификации = СтрЗаменить(СтрокаАутентификации, "&ИмяПользователя",    ПараметрыПодключения.ИмяПользователя);
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


// Выполняет проверку
// 
// Параметры:
//  ПараметрыПодключения 			- Структура - Параметры подключения к информационной базе (см. в ПолучитьПараметрыПодключения());
//
// Возвращаемое значение:
//  Булево - Признак успешного выполнения.
//
Функция ВыполнитьПроверкуКонфигурации(ПараметрыПодключения)
	
	Лог.Информация(НСтр("ru = 'Проверка конфигурации.'"));
	
	УправлениеКонфигуратором = УстановитьУправлениеКонфигуратором(ПараметрыПодключения);
	ПараметрыЗапуска = УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/ConfigurationRepositoryF " + ПараметрыПодключения.ПутьКХранилищу +
	" /ConfigurationRepositoryN " + ПараметрыПодключения.ПользовательХранилища);
	ПараметрыЗапуска.Добавить("/CheckConfig " + ПараметрыПодключения.КлючиПроверкиМодулей + " /Out " + ПараметрыПодключения.ПустьКФайлуРезультата);
	
	Попытка
		УправлениеКонфигуратором.ВыполнитьКоманду(ПараметрыЗапуска);
	Исключение
		Лог.Ошибка(СтрШаблон(НСтр("ru = 'Ошибка при проверке модулей.
			|%1'"), УправлениеКонфигуратором.ВыводКоманды()));
		Возврат Ложь;
	КонецПопытки;
	
	Лог.Отладка(НСтр("ru = 'Проверка модулей завершено.'"));
	
	Возврат Истина;
	
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
	
	УправлениеКонфигуратором.ИспользоватьВерсиюПлатформы(ПараметрыПодключения.ВерсияПлатформы);
	
	ФайловыйВариантРаботы = ПараметрыПодключения.ВариантРаботыИнформационнойБазы = 0;
	
	Если ФайловыйВариантРаботы Тогда
		СтрокаСоединения = "/F""&КаталогИнформационнойБазы""";
		СтрокаСоединения = СтрЗаменить(СтрокаСоединения, "&КаталогИнформационнойБазы", ПараметрыПодключения.КаталогИнформационнойБазы);
	Иначе
		СтрокаСоединения = "/S""&ИмяСервера1СПредприятия\&ИмяИнформационнойБазыНаСервере1СПредприятия""";
		СтрокаСоединения = СтрЗаменить(СтрокаСоединения, "&ИмяСервера1СПредприятия",                     ПараметрыПодключения.ИмяСервера1СПредприятия);
		СтрокаСоединения = СтрЗаменить(СтрокаСоединения, "&ИмяИнформационнойБазыНаСервере1СПредприятия",
		ПараметрыПодключения.ИмяИнформационнойБазыНаСервере1СПредприятия);
	КонецЕсли;
	
	Если ПараметрыПодключения.АутентификацияОперационнойСистемы Тогда
		ПараметрыПодключения.ИмяПользователя = "";
		ПараметрыПодключения.ПарольПользователя = "";
	КонецЕсли;
	
	УправлениеКонфигуратором.УстановитьКонтекст(СтрокаСоединения, ПараметрыПодключения.ИмяПользователя, ПараметрыПодключения.ПарольПользователя);
	УправлениеКонфигуратором.УстановитьКлючРазрешенияЗапуска("ПакетноеОбновлениеКонфигурацииИБ");
	
	Возврат УправлениеКонфигуратором;
	
КонецФункции

Лог = Логирование.ПолучитьЛог("oscript.app.AutoUpdateIB");
Инициализировать();