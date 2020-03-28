# Lab2

Lab2.pdf - Текущий отчёт, в котором представлены полученные графики и пояснения к ним
logs.txt - Пример логирования работы алгоритма в файл. Параметры (вероятность ошибки, tau и размер буфера указаны в начале файла). 
В логе + указаны полученные сообщения, - указаны не принятые сообщения. Указаны причины для не полученных сообщений: 
1) Ошибка в канале
2) Переполнение буфера
Указано состояние сообщений после получения: 
1) Отправлено получателю
2) Отправлено в буфер
3) Отправлено из буфера получателю

LabCreateLog.m - программа моделирования и вывода в лог-файл
LabP.m - программа моделирования и построения зависимости от вероятностей ошибки в канале
LabTao.m - программа моделирования и построения зависимости от tau

В программах можно менять параметры: p, tau, размер буфера, количество экспериментов
