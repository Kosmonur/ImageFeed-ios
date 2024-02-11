## **ImageFeed**

ImageFeed - это приложение для просмотра фотографий из сервиса Unsplash.
 - Пользователь может просматривать ленту фотографий, добавлять и удалять изображения из избранного (лайки).
 - Для просмотра фото необходима авторизация пользователя.
 - Если пользователь закрывает приложение, данные об авторизации сохраняются и при новом открытии авторизация не требуется.
Если пользователь выходит из приложения, то данные авторизации стираются.
 - Пользователь может перейти в экран своего профиля, чтобы посмотреть данные профиля или выйти из него.
 - Фото можно просматривать в отдельном окне в высоком качестве, а также масштабировать отдельные участки (мультитач - сведение/разведение пальцев).
 
## **Скрины приложения**

<img width="200" src="https://github.com/Kosmonur/ImageFeed-ios/blob/main/ImageFeed-ios/Assets.xcassets/ScreenShots/1.png"> <img width="200" src="https://github.com/Kosmonur/ImageFeed-ios/blob/main/ImageFeed-ios/Assets.xcassets/ScreenShots/2.png">

<img width="200" src="https://github.com/Kosmonur/ImageFeed-ios/blob/main/ImageFeed-ios/Assets.xcassets/ScreenShots/3.png"> <img width="200" src="https://github.com/Kosmonur/ImageFeed-ios/blob/main/ImageFeed-ios/Assets.xcassets/ScreenShots/4.png">

## Стек
- архитектура MVP
- вёрстка сторибордом и кодом с Auto Layout [Дизайн в Figma.](https://www.figma.com/file/HyDfKh5UVPOhPZIhBqIm3q/Image-Feed-(YP)?node-id=318-1469)
- UITableView, UIScrollView, UITapGestureRecognizer
- URLSession и пагинация запросов
- многопоточность; предотвращение race condition (DispatchQueue, блокировка UI)
- используемые библиотеки KingFisher, ProgressHUD, SwiftKeychainWrapper. Подключены через SPM.
- реализация авторизации с OAuth 2.0
- UI-тесты и Unit-тесты

## **Инструкция по установке**

- Запускается без дополнительных требований;


