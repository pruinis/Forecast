# Forecast

The application contains some design issues and inaccuracies because the lead time was short. I will gladly correct them all according to your comments.

I did not have a design for popup with a message for the user, so I left comments or a print(…) with errors in the code.
Also, I didn't have resources for icons in the Folder with task, for this reason I found them by myself, not all of them are convenient for proposed design.

Application has designed error related to outdated OpenWeatherMapKit dependency. It ignores “city” object while parsing Forecast. I added an extra geocoding request to fix this situation.

Possible solutions: Make Private CocoaPods repo and add parsing for “city” there (Had experience with distribution of Private CocoaPods).

# If that matters, I will gladly do:

## Suggestions & Proposals:
- Add Unit & UI tests
- Replace Storyboard with SwiftUI
- Corrections in UI

## Used libraries:
### Dependency manager: CocoaPods
- OpenWeatherMapKit, it can be forked and fixed 
- Swinject and SwinjectStoryboard, automatic dependency injection
- SwiftLocation, location tracking and geocoding
- SwiftSpinner, it can be replaced by UIActivityIndicatorView if needed

