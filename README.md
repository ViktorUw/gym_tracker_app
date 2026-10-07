# Gym Tracker App

A cross-platform workout tracker built with **Flutter**. Create training plans, log your gym sessions set by set, watch exercise videos and follow your body weight on a chart. All data is stored on the device.

## Features

- **User profile** with registration and editable data
- **Exercise library** with descriptions and demo videos
- **Training plans**: create your own plans and add exercises to them
- **Training sessions**: start a workout from a plan, log the sets and see a summary at the end
- **Training history** with the details of every completed workout
- **Body weight tracking** with a line chart
- **CSV export** of a workout or of your weight history, shared through the system share sheet

## Tech stack

- **Flutter** / **Dart** (SDK ^3.7.2)
- **sqflite** – local SQLite database
- **provider** – state management (MVVM: views, view models, repositories)
- **fl_chart** – weight chart
- **video_player** – exercise videos
- **share_plus**, **path_provider** – CSV export and sharing

## Project structure

```
lib/
├── main.dart, mainPage.dart   # Entry point and main navigation
├── models/                    # User, exercises, plans, trainings, weight
├── repositories/              # Database access per entity
├── services/                  # Database setup, seed data, CSV export
├── view_models/               # State for views (provider)
└── views/                     # Screens
assets/
├── videos/                    # Exercise demo videos
└── icon.png                   # App icon
```

The `lib/*.drawio` files contain the architecture, database schema and screen diagrams (open them with [diagrams.net](https://app.diagrams.net/)).

## Getting started

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. Clone the repository and install dependencies:
   ```bash
   git clone https://github.com/ViktorUw/gym_tracker_app.git
   cd gym_tracker_app
   flutter pub get
   ```
3. Run it on a connected device or emulator:
   ```bash
   flutter run
   ```

> The interface is in Polish.
