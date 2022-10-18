#Использовать logos
#Использовать v8runner

Перем Лог;
Перем ИнтервалыОжидания;

//////////////////////////////////////////////////////////////////////////////////////
// Инициализация

// Инициализация параметров
Функция Инициализировать()

	ИнтервалыОжидания = Новый Структура();
	ИнтервалыОжидания.Вставить("ЗавершениеРаботыПользователей", 120); // Максимальный интервал ожидания завершения сеансов пользователей. 
	ИнтервалыОжидания.Вставить("ЗавершениеСеансовФайловойИБ", 	60); // Максимальный интервал ожидания завершения сеанса файловой информационной базы.
	ИнтервалыОжидания.Вставить("ЗавершениеСеансовСервернойИБ", 	2); // Интервал ожидания завершения сеанса клиент-серверной информационной базы.
	ИнтервалыОжидания.Вставить("ОжиданиеУстановкиБлокировкиСеансов", 300); // Интервал ожидания от установки времени до начала блокировки.
	

	//////////////////////////////////////////////////////////////////////////////////////
	// Пример

	ПараметрыПодключения = ПолучитьПараметрыПодключения(1,,"cv8app12:1741", "1740", "ERP-DEV-Romantsov_s", Истина, , , "tcp://DB01/ERP", "romantsov_s", "");
	ЗагрузитьКонфигурациюИзФайлов(ПараметрыПодключения, "w:\1C_group\romantsov_s\OneScript\SaveConfigFiles\src_merged\", "w:\1C_group\romantsov_s\OneScript\SaveConfigFiles\list_Load.txt");

КонецФункции


///////////////////////////////////////////////////////////////////////////////
// Получение параметров конфигурации

// Получает параметры подключения к информационной базе.
	// 
	// Параметры:
	//  ВариантРаботыИнформационнойБазы		- Число  - Вариант работы информационной базы: 0 - файловый; 1 - клиент-серверный;
	//  КаталогИнформационнойБазы			- Строка - Каталог информационной базы для файлового режима работы;
	//  ИмяСервера1СПредприятия			- Строка - Имя сервера 1С:Предприятия;
	//  ИмяИнформационнойБазыНаСервере1СПредприятия - Строка - Имя информационной базы на сервере 1С:Предприятия;
	//  АутентификацияОперационнойСистемы		- Булево - Признак аутентификации операционной системы при создании внешнего подключения к информационной базе;
	//  ИмяПользователя				- Строка - Имя пользователя информационной базы;
	//  ПарольПользователя				- Строка - Пароль пользователя информационной базы;
	//  ВерсияПлатформы				- Строка - Версия платформы (82, 83).
	// 	
	// Возвращаемое значение:
	//  Структура, Неопределено - Параметры подключения к информационной базе, неопределено в случае ошибки.
	//
Функция ПолучитьПараметрыПодключения(ВариантРаботыИнформационнойБазы = 0, КаталогИнформационнойБазы = "", ИмяСервера1СПредприятия = "",
						ПортАгентаСервера = "", ИмяИнформационнойБазыНаСервере1СПредприятия = "", АутентификацияОперационнойСистемы = Ложь,
						ИмяПользователя = "Администратор", ПарольПользователя = "", ПутьКХранилищу = "", ПользовательХранилища = "",
						ПарольХранилища = "", ВерсияПлатформы = "83")

	Лог.Информация("------------------------------------------------------------");
	Лог.Информация(СтрШаблон(НСтр("ru = 'Информационная база %1.'"), 
		?(ВариантРаботыИнформационнойБазы = 0, КаталогИнформационнойБазы, ИмяИнформационнойБазыНаСервере1СПредприятия)));
	Лог.Информация("------------------------------------------------------------");

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
	
	ПараметрыПодключения.Вставить("ПутьКХранилищу", ПутьКХранилищу);
	ПараметрыПодключения.Вставить("ПользовательХранилища", ПользовательХранилища);
	ПараметрыПодключения.Вставить("ПарольХранилища", ПарольХранилища);

	РезультатВыполнения = ПроверитьКорректностьПараметровПодключения(ПараметрыПодключения);
	Если Не РезультатВыполнения Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПараметрыПодключения; 
	
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

// Обновляет конфигурацию из хранилища
	// 
	// Параметры:
	//  ПараметрыПодключения 			- Структура - Параметры подключения к информационной базе (см. в ПолучитьПараметрыПодключения());
	//
	// Возвращаемое значение:
	//  Булево - Признак успешного выполнения.
	//
Функция ЗагрузитьКонфигурациюИзФайлов(ПараметрыПодключения, Каталог, ПутьКСпискуФайловЗагрузки)
	
	Лог.Информация(СтрШаблон(НСтр("ru = 'Загрузка конфигурации из файлов %1, %2'"), Каталог, ПутьКСпискуФайловЗагрузки));
			
	Если Не ОбеспечитьКаталог(Каталог) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	УправлениеКонфигуратором = УстановитьУправлениеКонфигуратором(ПараметрыПодключения);
	
	Попытка
		УправлениеКонфигуратором.ЗагрузитьКонфигурациюИзФайлов(Каталог, ПутьКСпискуФайловЗагрузки, , Ложь, ПараметрыПодключения.ПутьКХранилищу, ПараметрыПодключения.ПользовательХранилища,
									ПараметрыПодключения.ПарольХранилища);
	Исключение
		Лог.Ошибка(СтрШаблон(НСтр("ru = 'Ошибка при загрузке конфигурации из файлов.
			|%1'"), УправлениеКонфигуратором.ВыводКоманды()));
		Возврат Ложь;
	КонецПопытки;
	
	Лог.Отладка(НСтр("ru = 'Загружено успешно.'"));
	
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
		СтрокаСоединения = СтрЗаменить(СтрокаСоединения, "&ИмяСервера1СПредприятия",                     ПараметрыПодключения.ИмяСервера1СПредприятия);
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

Лог = Логирование.ПолучитьЛог("oscript.app.SaveConfigFiles");
Лог.УстановитьУровень(УровниЛога.Отладка);
Логирование.ПолучитьЛог("oscript.lib.v8runner").УстановитьУровень(Лог.Уровень());
Инициализировать();