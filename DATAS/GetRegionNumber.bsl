#Область БазисПрограммирования
Функция GetRegionNumber(Знач strFullGovNumber)       
	strGovNumber = СокрЛП(strFullGovNumber);
	numIndStr = СтрДлина(strGovNumber);
	Пока numIndStr > 0 Цикл 
		strChar = Сред(strGovNumber, numIndStr, 1);
		numInd = СтрНайти("0123456789", strChar);
		Если numInd < 1 Тогда
			Прервать;
		КонецЕсли;
		numIndStr = numIndStr - 1;
	КонецЦикла;
	Возврат  Сред(strGovNumber, numIndStr+1, СтрДлина(strGovNumber)-numIndStr);
КонецФункции

#КонецОбласти
