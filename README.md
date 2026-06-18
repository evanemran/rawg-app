# RAWG

A modern video games discovery app built with **Flutter**. Browse trending games, search the catalog, and dive into rich game details — all powered by the [RAWG Video Games Database API](https://rawg.io/apidocs).

---

## Overview

RAWG lets you explore one of the largest open video game databases. The home screen surfaces featured and popular titles, the explore screen offers live search with infinite scrolling, and each game opens a detailed view with screenshots, platforms, ratings, system requirements, and more.

## Features

- **Home** — Featured carousel, "Popular Now" rail, and browse-by-genre chips.
- **Explore** — Live, debounced search with **lazy loading / infinite scroll** pagination.
- **Game details** — Hero artwork, description, stats (Metacritic, rating, playtime), genres, ratings breakdown, platforms, PC system requirements, stores ("where to buy"), screenshots, and tags.
- ** More Coming Soon

## Screenshots

Here are some screenshots.

<img src = "assets/rawg.png">

## Tech Stack

| Concern            | Choice                                                                 |
| ------------------ | --------------------------------------------------------------------- |
| Framework          | [Flutter](https://flutter.dev) (Dart 3)                               |
| State management   | [Riverpod](https://riverpod.dev) (`flutter_riverpod`)                 |
| UI design          | **Material 3** with a custom dark theme                               |
| Networking         | [`http`](https://pub.dev/packages/http)                              |
| Data source        | [RAWG API](https://rawg.io/apidocs)                                  |                            |

## Architecture

The project follows **Clean Architecture**, separating the code into three layers with a clear, one-directional dependency flow (`presentation → domain ← data`):

- **Domain** — Pure business layer. Holds models, repository contracts (abstractions), and use cases. It has no dependency on Flutter or any external package implementation.
- **Data** — Implements the domain repository contracts. Talks to the RAWG API and maps raw JSON into domain models.
- **Presentation** — Flutter UI (pages and widgets) plus Riverpod providers that wire use cases to the screens.

This keeps the UI decoupled from the network layer: pages depend on use cases, use cases depend on repository abstractions, and only the data layer knows about the actual API.

### Data flow

```
Widget → Provider → UseCase → Repository (abstract) → RepositoryImpl → RawgApi → RAWG
```

### Project structure

```
lib/
├── main.dart                     # App entry point + ProviderScope
├── app/
│   ├── constants/                # API base URL, key, and endpoint paths
│   └── theme/                    # Material 3 dark theme + color palette
├── data/
│   ├── providers/                # RawgApi (HTTP client wrapper)
│   └── repositories/             # Repository implementations
├── domain/
│   ├── models/                   # Data models (Games, GameSingle, Genre, ...)
│   ├── repositories/             # Repository abstractions (contracts)
│   └── usecases/                 # Use cases (GetGames, SearchGames, ...)
└── presentation/
    ├── pages/                    # Screens (home, explore, details, drawer, ...)
    ├── providers/                # Riverpod providers
    └── widgets/                  # Reusable UI components
```

## State Management

State is managed with **Riverpod**. The dependency graph is composed from small, testable providers:

- `rawgApiProvider` → `rawgRepositoryProvider` → use-case providers (e.g. `getGamesProvider`, `searchGamesProvider`).
- `FutureProvider.family` providers expose async data to the UI (e.g. games list, game details, genres) with automatic loading/error/data states.
- Lightweight UI state (selected bottom-nav tab, drawer selection) uses `StateProvider`.

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart 3.x)
- A device or emulator/simulator

### Setup

1. Clone the repository and fetch dependencies:

   ```bash
   git clone <repo-url>
   cd rawg_app
   flutter pub get
   ```

2. Add your RAWG API key.

   Get a free key from [rawg.io/apidocs](https://rawg.io/apidocs) and set it in `lib/app/constants/api_constants.dart`:

   ```dart
   static const String apiKey = "YOUR_RAWG_API_KEY";
   ```

3. Run the app:

   ```bash
   flutter run
   ```

## API Attribution

Game data and images are provided by the [RAWG Video Games Database API](https://rawg.io/apidocs). Per RAWG's terms of use, attribution to RAWG as the data source is required.
