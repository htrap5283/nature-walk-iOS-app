# G11 Nature Walk App

![SwiftUI](https://img.shields.io/badge/SwiftUI-2.0-orange) ![Firebase](https://img.shields.io/badge/Firebase-9.0-yellow) ![iOS](https://img.shields.io/badge/iOS-14.0-blue)

## 📋 Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Using CocoaPods](#using-cocoapods)
  - [Using Swift Package Manager (SPM)](#using-swift-package-manager-spm)
  - [Using Carthage](#using-carthage)
- [Running the App](#running-the-app)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## 🚀 Introduction

The **G11 Nature Walk App** is an iOS application developed using **SwiftUI** and **Firebase**. This application is designed for a recreation facility that promotes "Group Nature Walk Sessions" around the city. The app allows users to explore various nature walk sessions, manage bookings, view sessions, and maintain their profile effortlessly.

## 🌟 Features

- **User Authentication**: Secure login functionality with Firebase Authentication.
- **Nature Walk Sessions**: Browse, view details, and book available sessions.
- **Favorite Sessions**: Add sessions to favorites and manage your favorite list.
- **Ticket Purchases**: Buy tickets for your desired nature walks and view your purchase history.
- **Profile Management**: Update and maintain user profiles, including contact and payment information.
- **Map Integration**: View session locations on a map and interact with venue addresses.
- **Sharing**: Share session details with others via the iOS share sheet.
- **Logout**: Securely log out from the application with a single tap.

## 🛠️ Prerequisites

Before you begin, ensure you have the following installed:

- **Xcode**: Version 12 or later
- **iOS Device**: iOS 14 or later
- **CocoaPods**: For managing Firebase dependencies (if using this method)
- **Carthage**: For alternative dependency management (if using this method)
- **Swift Package Manager (SPM)**: Integrated within Xcode

## 🔧 Installation

### Using CocoaPods

1. **Install CocoaPods** (if not already installed)

```bash
sudo gem install cocoapods
```

Clone the Repository

```bash
git clone https://github.com/yourusername/g11-naturewalk.git
cd g11-naturewalk
```

Install Dependencies

Open the terminal and navigate to the project directory, then run:

```bash
pod install
```

This will install all necessary dependencies, including Firebase.

Open the Workspace

Open the .xcworkspace file in Xcode.

Using Swift Package Manager (SPM)
Open Your Project in Xcode

Go to File > Swift Packages > Add Package Dependency...
Enter the Firebase GitHub repository URL: https://github.com/firebase/firebase-ios-sdk.git
Choose Dependencies

Select the Firebase libraries you need, such as FirebaseAuth and FirebaseFirestore.
Integrate Firebase

Follow the setup instructions for Firebase, including downloading the GoogleService-Info.plist file and adding it to your project.
Using Carthage
Install Carthage (if not already installed)

```bash

brew install carthage
```

Create a Cartfile

Add the following to your Cartfile:

github "firebase/firebase-ios-sdk" ~> 9.0

Install Dependencies
Run the following command in your project directory:

```bash

carthage update --platform iOS
```

Integrate Frameworks

Drag the built frameworks from Carthage/Build/iOS into your Xcode project.
Ensure they are linked in the "General > Frameworks, Libraries, and Embedded Content" section of your target settings.
Configure Firebase

Follow the setup instructions for Firebase, including downloading the GoogleService-Info.plist file and adding it to your project.
🏃 Running the App
Open the .xcworkspace file in Xcode (if using CocoaPods) or the .xcodeproj file if using SPM or Carthage.
Select your target device or simulator.
Build and run the project using the play button in Xcode.
📁 Project Structure
Here's a brief overview of the project's file structure:

```
G11-NatureWalkApp
├── G11-NatureWalkApp.xcodeproj      # Xcode project files
├── G11-NatureWalkApp.xcworkspace    # Xcode workspace for Cocoapods
├── GoogleService-Info.plist         # Firebase configuration file
├── Models                           # Data models
│   ├── FavouriteSession.swift
│   ├── PurchaseSession.swift
│   ├── Session.swift
│   └── Users.swift
├── Views                            # SwiftUI views
│   ├── ContentView.swift
│   ├── FavouritesListView.swift
│   ├── MainTabView.swift
│   ├── ProfileView.swift
│   ├── PurchaseDetailView.swift
│   ├── PurchaseListView.swift
│   ├── PurchaseSessionView.swift
│   ├── SessionDetailsView.swift
│   ├── SessionListView.swift
│   └── SignInView.swift
├── Controllers                      # ViewModels for managing state
│   ├── FireAuthHelper.swift
│   └── FireDBHelper.swift
└── G11_NatureWalkApp.swift          # Main entry point
```

🧑‍💻 Usage
Here's a brief guide on how to use the app:

Sign-In

Open the app and enter your email and password to access the main dashboard.
Enable the "Remember Me" checkbox for future automatic login.
Browse Sessions

View a list of available nature walk sessions with details like name, price, and rating.
Tap on a session to view detailed information, including images, description, and guide information.
Manage Favorites

Add sessions to your favorites list for easy access.
Navigate to the "Favourites" tab to view and manage your favorite sessions.
Purchase Tickets

Purchase tickets for your desired sessions and view purchase details.
Access your purchase history under the "Purchase" tab.
Profile Management

Edit and update your profile information, including contact and payment details.
Securely log out from the profile screen when needed.
Location and Sharing

View session venues on a map and get directions.
Share session details with others using the iOS share sheet.
🤝 Contributing
Contributions are always welcome! Here are some ways you can help:

Reporting Bugs: Use the issue tracker to report bugs.
Suggesting Enhancements: Propose improvements or new features.
Pull Requests: Fork the repository and submit pull requests.
Pull Request Process
Fork the repository.
Create a new branch (git checkout -b feature/YourFeatureName).
Make your changes and commit (git commit -m 'Add some feature').
Push to the branch (git push origin feature/YourFeatureName).
Open a pull request.
Please ensure your code follows the project's coding style and includes relevant documentation.

📜 License
This project is licensed under the MIT License - see the LICENSE file for details.

📬 Contact
If you have any questions or feedback, feel free to reach out:

Email: parthjp5283@gmail.com
GitHub: htrap5283

🔍 Additional Notes
Firebase Security Rules: Ensure your Firestore and Authentication security rules are set appropriately to protect user data.
iOS Updates: Stay up to date with the latest iOS SDK versions to benefit from new features and security improvements.
