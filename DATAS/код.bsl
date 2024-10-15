	тзТаблицаИзменений = Новый ТаблицаЗначений();
	тзТаблицаИзменений.Колонки.Добавить("Работы", Новый ОписаниеТипов("СправочникСсылка.РегламентныеРаботы"));
	тзТаблицаИзменений.Колонки.Добавить("Конструкции", Новый ОписаниеТипов("СправочникСсылка.Конструкции"));
	Для Каждого тСтр Из тзДобавленныхКонструкций Цикл
		Стр = тзТаблицаИзменений.Добавить();
		ЗаполнитьЗначенияСвойств(Стр, тСтр);
	КонецЦикла;
	Для Каждого тСтр Из тзУдаленныхКонструкций Цикл
		Стр = тзТаблицаИзменений.Добавить();
		ЗаполнитьЗначенияСвойств(Стр, тСтр);
	КонецЦикла;

	реквТаблицаКонструкций.Очистить();
	ЗначениеВРеквизитФормы(тзТаблицаИзменений, "реквТаблицаКонструкций");
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		МенеджерВТ = Новый МенеджерВременныхТаблиц;
	
		ЗапросСозданиеВременныхТаблиц = Новый Запрос;
		ЗапросСозданиеВременныхТаблиц.МенеджерВременныхТаблиц = МенеджерВТ;
		ЗапросСозданиеВременныхТаблиц.Текст = "ВЫБРАТЬ Т.Конструкция ПОМЕСТИТЬ ВТОтмеченныхКонструкций ИЗ &Таб КАК Т;
		|	ВЫБРАТЬ
		|		Р.Конструкции КАК Конструкции
		|	ПОМЕСТИТЬ 
		|		ВТРаботыПоКонструкциям
		|	ИЗ
		|		РегистрСведений.РаботыПоКонструкциям КАК Р
		|	ГДЕ
		|		Р.Работы = &Работы";
		ЗапросСозданиеВременныхТаблиц.УстановитьПараметр("Таб",тзТаблицаКонструкцийИстина);
		ЗапросСозданиеВременныхТаблиц.УстановитьПараметр("Работы", Объект.НаименованиеРаботы);
		ЗапросСозданиеВременныхТаблиц.Выполнить();
    	
		ЗапросДобавленныхКонструкций = Новый Запрос;
		ЗапросДобавленныхКонструкций.Текст = "ВЫБРАТЬ
		|		&Работы КАК Работы,
		|		К.Конструкция КАК Конструкции
		|	ИЗ
		|		ВТОтмеченныхКонструкций КАК К
		|			ЛЕВОЕ СОЕДИНЕНИЕ ВТРаботыПоКонструкциям КАК Р
		|			ПО Р.Конструкции = К.Конструкция
		|	ГДЕ
		|		Р.Конструкции ЕСТЬ NULL";
		ЗапросДобавленныхКонструкций.МенеджерВременныхТаблиц = МенеджерВТ;
		ЗапросДобавленныхКонструкций.УстановитьПараметр("Работы", Объект.НаименованиеРаботы);
		РезультатЗапросДобавленныхКонструкций = ЗапросДобавленныхКонструкций.Выполнить();
		тзДобавленныхКонструкций = РезультатЗапросДобавленныхКонструкций.Выгрузить(ОбходРезультатаЗапроса.Прямой);
		
		ЗапросУдаленныхКонструкций = Новый Запрос;
		ЗапросУдаленныхКонструкций.Текст = "ВЫБРАТЬ
		|		&Работы КАК Работы,
		|		Р.Конструкции КАК Конструкции
		|	ИЗ
		|		ВТОтмеченныхКонструкций КАК К
		|			ПРАВОЕ СОЕДИНЕНИЕ ВТРаботыПоКонструкциям КАК Р
		|			ПО Р.Конструкции = К.Конструкция
		|	ГДЕ
		|		К.Конструкция ЕСТЬ NULL";
		ЗапросУдаленныхКонструкций.МенеджерВременныхТаблиц = МенеджерВТ;
		ЗапросУдаленныхКонструкций.УстановитьПараметр("Работы", Объект.НаименованиеРаботы);
		РезультатЗапросУдаленныхКонструкций = ЗапросУдаленныхКонструкций.Выполнить();
		тзУдаленныхКонструкций = РезультатЗапросУдаленныхКонструкций.Выгрузить(ОбходРезультатаЗапроса.Прямой);
		
		//Если тзУдаленныхКонструкций.Количество() > 0 Тогда
		//	МенеджерЗаписи = РегистрыСведений.РаботыПоКонструкциям.СоздатьМенеджерЗаписи();
		//	МенеджерЗаписи.Работы = Объект.НаименованиеРаботы;
		//	Для Каждого Стр Из тзУдаленныхКонструкций Цикл
		//		МенеджерЗаписи.Конструкции = Стр.Конструкции;
		//		МенеджерЗаписи.Прочитать();
		//		МенеджерЗаписи.Удалить();
		//	КонецЦикла;
		//КонецЕсли;
		Если тзДобавленныхКонструкций.Количество() > 0 Тогда 
			НаборДобавляемыхЗаписей = РегистрыСведений.РаботыПоКонструкциям.СоздатьНаборЗаписей();
			НаборДобавляемыхЗаписей.Загрузить(тзДобавленныхКонструкций);
			НаборДобавляемыхЗаписей.Записать();
		КонецЕсли;
			
		
		Если Объект.ПоказВсехКонструкций Тогда
			ЗагрузитьВсеДеревоКонструкцийНаСервере();
		Иначе 
			ЗагрузитьЧастьДеревоКонструкцийНаСервере();
		КонецЕсли;
////////////////////////////////////////////////////////////////////////		
		тзТаблицаИзменений = Новый ТаблицаЗначений();
		тзТаблицаИзменений.Колонки.Добавить("Дебет", Новый ОписаниеТипов("СправочникСсылка.Конструкции"));
		тзТаблицаИзменений.Колонки.Добавить("Кредет", Новый ОписаниеТипов("СправочникСсылка.Конструкции"));
		Для Каждого тСтр Из тзДобавленныхКонструкций Цикл
			Стр = тзТаблицаИзменений.Добавить();
			//ЗаполнитьЗначенияСвойств(Стр, тСтр);
			Стр.Дебет = тСтр.Конструкции;
		КонецЦикла;
		Для Каждого тСтр Из тзУдаленныхКонструкций Цикл
			Стр = тзТаблицаИзменений.Добавить();
			//ЗаполнитьЗначенияСвойств(Стр, тСтр);
			Стр.Кредет = тСтр.Конструкции;
		КонецЦикла;
		реквТаблицаКонструкций.Очистить();
		ЗначениеВРеквизитФормы(тзТаблицаИзменений, "реквТаблицаКонструкций");
////////////////////////////////////////////////////////////////////////
&НаСервере
Процедура ЗагрузитьЧастьДеревоКонструкцийНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СправочникКонструкций.Ссылка КАК Конструкция,
	|	ВЫБОР
	|		КОГДА НЕ (РаботыПоКонструкциям.Конструкции ЕСТЬ NULL) И РаботыПоКонструкциям.Работы = &Работы
	|			ТОГДА Истина
	|			ИНАЧЕ Ложь
	|		КОНЕЦ КАК Назначенность
	|	ИЗ
	|   	Справочник.Конструкции КАК СправочникКонструкций
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботыПоКонструкциям КАК РаботыПоКонструкциям
	|			ПО СправочникКонструкций.Ссылка = РаботыПоКонструкциям.Конструкции И РаботыПоКонструкциям.Работы = &Работы
	|	ГДЕ СправочникКонструкций.Система = &Система
    |	УПОРЯДОЧИТЬ ПО
    |		Конструкция ИЕРАРХИЯ";
    Запрос.УстановитьПараметр("Работы", Объект.НаименованиеРаботы);
	Запрос.УстановитьПараметр("Система", Объект.Система);
	ДеревоЗначений = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ЗначениеВРеквизитФормы(ДеревоЗначений, "реквДеревоКонструкций");
КонецПроцедуры
////////////////////////////////////////////////////////////////////////
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Если ТекущийОбъект.Система.Пустая() Тогда
		Если Не ТекущийОбъект.Родитель.Пустая() Тогда
			Если Не ТекущийОбъект.Родитель.Система.Пустая() Тогда
				ТекущийОбъект.Система = ТекущийОбъект.Родитель.Система;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не Объект.Родитель.Пустая() Тогда
		Если Не Объект.Родитель.Система.Пустая() Тогда 
			Объект.Система = Объект.Родитель.Система;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура полеРаботыПриИзмененииНаСервере(ТекстНаименования)
	РегламентнаяРабота = Справочники.РегламентныеРаботы.НайтиПоНаименованию(ТекстНаименования, Истина);
	ЭтаФорма.ПолноеНаименованиеРаботы = РегламентнаяРабота.ПолноеНаименование;
	ЭтаФорма.СистемаРаботы = РегламентнаяРабота.Система;
КонецПроцедуры

&НаКлиенте
Процедура полеРаботыПриИзменении(Элемент)
	полеРаботыПриИзмененииНаСервере(Элемент.ВыделенныйТекст);
КонецПроцедуры


&НаСервере
Процедура полеУстройстваПриИзмененииНаСервере(ТекстНаименования)
	ОбслуживаемоеУстройство = Справочники.Конструкции.НайтиПоНаименованию(ТекстНаименования, Истина);
	ЭтаФорма.СистемаУстройства = " - " ; //+ ОбслуживаемоеУстройство.Система.Наименование;
КонецПроцедуры


&НаКлиенте
Процедура полеУстройстваПриИзменении(Элемент)
	полеУстройстваПриИзмененииНаСервере(Элемент.ВыделенныйТекст);
КонецПроцедуры


		
