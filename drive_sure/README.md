# DriveSure - Car Rental App

A modern car rental application built with Flutter that allows users to browse, book, and manage car rentals.

## Features

- User authentication (login, register, password reset)
- Browse available cars with filtering and search
- Detailed car information and specifications
- Booking system with date selection
- Additional services (insurance, GPS, child seat)
- User profile and booking history
- Favorite cars management

## Project Structure

The project follows a clean architecture pattern with the following structure:

- lib/models: Data models (Car, User)
- lib/providers: State management (AuthProvider, CarProvider)
- lib/screens: UI screens (Login, Home, CarDetail, Booking)
- lib/services: API services (AuthService, CarService)
- lib/widgets: Reusable widgets (CarCard, FeatureCard)

## Setup

1. Install Flutter
2. Clone the repository
3. Run `flutter pub get`
4. Run `flutter run`

## Dependencies

Main dependencies used in the project:
- provider: State management
- http: API calls
- intl: Date formatting
- shared_preferences: Local storage