
# Rewardly App Blueprint

## Overview

Rewardly is a mobile application that allows users to earn rewards by completing tasks. The app is built with Flutter and uses Firebase for authentication and other backend services.

## Features

*   **Authentication:** Users can sign up and log in with their email and password.
*   **Splash Screen:** A loading screen is displayed when the app is first launched.
*   **Home Screen:** The main screen of the app, which is displayed after the user logs in.
*   **Theme Management:** The app supports both light and dark themes, which can be toggled by the user.
*   **Navigation:** The app uses `go_router` for declarative navigation.

## Design

*   **Typography:** The app uses the `google_fonts` package to provide a consistent and modern typography.
*   **Color Scheme:** The app uses `ColorScheme.fromSeed` to generate a harmonious color palette.
*   **Component Styling:** The app includes custom styling for a variety of Material components, including `AppBar` and `ElevatedButton`.

## Architecture

*   **State Management:** The app uses the `provider` package for state management, with separate providers for authentication and theme management.
*   **Services:** The app uses a service layer to abstract away the details of interacting with Firebase.
*   **Routing:** The app uses `go_router` for declarative routing, which simplifies the navigation logic and makes it easier to handle deep linking.
