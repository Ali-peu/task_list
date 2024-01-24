# task_list

A new Flutter project.

## Getting Started

0. Пререквизиты. (Версия флаттера, дарта, градла и .т.п)
    Flutter: 3.16.7
    Dart SDK version: 3.2.3 (stable)
1. Краткое описание проекта (+ информация о архитектуре)
    Приложение для отслежавание задач для разных представителей компании. Приложение работатет на локольном хранилище, пока что не синхронизированы с серверной части. Было написано используя BloC (блочную) архитектуру.
2. Поддерживаемые Платформы
    Web
    Android
3. Список зависимостей (импортируемые пакеты и т.п.)
    cupertino_icons: ^1.0.2
    uuid: ^4.2.2
    flutter_bloc: ^8.1.3
    firebase_core: ^2.24.2
    firebase_auth: ^4.15.3
    bloc: ^8.1.2
    flutter_multi_formatter: ^2.12.3
    equatable: ^2.0.5 
    choice: ^2.3.0 Пакет для смены статуса
    provider: ^6.1.1 
    user_repository: Пакет для авторизации пользователя в серверной части
        path: packages/user_repository
    hive_flutter: ^1.1.0
    flutter_localizations:  Пакет для локализации
        sdk: flutter 

4. Инструкция по развертыванию (если необходимо) и настройке 
    Нужно разрешение для уведомление
5. Список фич с отметками что сделано а что ещё нет.
    1. Связано с сервером 1с локально 
6. Прочее (Здесь могу быть всякие комментарии, например о том что есть какой либо нюанс функционала и т.п.)
    1. https://docs.google.com/document/d/1uIfUGckhnFTMeG6fCBpKfOhVaadlkmNDhq5q7sv9YIo/edit краткая презентация
    2. Надо перенести ситему уведомление firebase FCM со старого на новую версию до 24 июня 
   3. Проверить насколько времени будет актуально phoneId fCMToken у устройства и обнавить в зависимости от ответа сперва в Firebase, потом в боксе 