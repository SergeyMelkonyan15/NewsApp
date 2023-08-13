# NY Times Most Popular Articles Viewer

This is a showcase iOS app to fetch and display the NY Times Most Popular Articles. Users can view a list of articles and see detailed information by tapping on any article from the list.

## Getting Started

### Prerequisites

- **Xcode**

- **Swift**

- **API Key**: Obtain an API key from the NY Times Developer portal [here](https://developer.nytimes.com/get-started).

### Setup

1\. **Clone the Repository**: 

   ```bash

   git clone [<repo_url>](https://github.com/SergeyMelkonyan15/NewsApp.git)
1.  **Open in Xcode**: Navigate to the project directory
2.  **Insert API Key**: Open the AppDelegate file and replace apiKey with your personal NY Times Developer API key.

API Details
-----------

The app hits into the "most viewed" section of the NY Times Most Popular Articles API:
http://api.nytimes.com/svc/mostpopular/v2/viewed/{period}.json?api-key=sample-key
To experiment with the API, adjust API.EndPoint file to add or remove the periods. Valid `period` values include `1`, `7`, and `30`. In the app it is presented as "Daily", "Weekly" and "30 days" filters

<https://api.nytimes.com/svc/mostpopular/v2/viewed/7.json?api-key=sample-key>

Development Approach
--------------------

-   **Object-Oriented Programming**: The app follows an Object-Oriented Programming (OOP) approach.
-   **MVVM Architecture**: Uses the MVVM (Model-View-ViewModel) architecture design pattern.
-   **Testing**: The networking layer is unit tested using XCTest.
-   **Coding Standards**: The code adheres to Swift's best practices and coding standards.

UI Approach
-----------
- The app's main flow is based on the master/detail pattern which is implemented using UISplitViewController officially recommended by Apple https://developer.apple.com/documentation/uikit/uisplitviewcontroller


Running the App
---------------

1.  Build and execute the app using Xcode.

Running Tests and Generating Reports
-------------

1.  Open XCode and use ⌘ + U to run all the tests and generated reports


