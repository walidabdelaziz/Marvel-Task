# Marvel Challenge - iOS

This project is a simple example of how to fetch marvel characters and display them in a list, and when clicking on any character in the list, it should navigate to a character details screen that shows more information about the selected character. The project uses the following frameworks and technologies:

- [x] MVVM design pattern
- [x] RxSwift for reactive programming
- [x] Alamofire for networking
- [x] Kingfisher for image caching and downloading
- [x] NVActivityIndicatorView for loader
- [x] Realm for caching data to work at offline mode

## Requirements

iOS 16 or later
Swift 5 or later

## Installation

Clone the repository or download the zip file and extract it to your preferred location.
Open the terminal and navigate to the project directory.
Run pod install to install the required dependencies.

## MVVM Architecture

The app follows MVVM (Model-View-ViewModel) architecture, which separates the responsibilities of the app into three layers:

Model: Contains the data and business logic of the app.
View: Contains the UI elements and user interactions of the app.
ViewModel: Binds the Model and View together and provides the necessary data and actions for the View to render and interact with.
The ViewModel layer is responsible for the business logic of the app, and uses RxSwift to bind the data from the Model layer to the View layer. This way, the ViewModel layer only communicates with the View layer via the data bindings and the View layer never has direct access to the data.

## Pagination

The app implements pagination when the user reaches the end of the table view. This way, the app can fetch more photos from the API without fetching all of the photos at once.

## Conclusion

This app serves as a demonstration of advanced programming concepts the power of RxSwift within the context of a simple yet effective characters-fetching application.
