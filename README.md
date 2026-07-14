# Currency Canvas 💱

A premium currency converter built with Flutter — featuring a Dark Forest + Copper theme, glassmorphism UI, real-time exchange rates from 200+ currencies, and smooth micro-animations.

---


## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.44+ |
| Language | Dart 3.12+ |
| API | [Exchange API](https://github.com/fawazahmed0/exchange-api) |
| HTTP | `http` |
| Fonts | `google_fonts` (Outfit) |
| Animations | `flutter_animate` |
| Persistence | `shared_preferences` |
| Formatting | `intl` |
| Sharing | `share_plus` |

---

## API

This app uses the free [Exchange API](https://github.com/fawazahmed0/exchange-api) by fawazahmed0.

---

## Folder Structure

```
lib/
├── main.dart                  # App entry point, theme management
├── constants/
│   ├── api_constants.dart     # API URL builder with fallback
│   ├── app_colors.dart        # Color palette (dark + light)
│   └── app_theme.dart         # ThemeData definitions
├── models/
│   ├── currency.dart          # Currency model
│   └── conversion_result.dart # Conversion result with serialization
├── services/
│   ├── exchange_service.dart  # API communication + caching
│   └── storage_service.dart   # SharedPreferences wrapper
├── screens/
│   └── home_screen.dart       # Main converter screen
├── utils/
│   ├── currency_flags.dart    # Currency code → flag emoji mapper
│   └── formatters.dart        # Number/date formatting utilities
└── widgets/
    ├── glass_card.dart              # Glassmorphism card
    ├── gradient_button.dart         # Animated gradient button
    ├── currency_selector.dart       # Currency display tile
    ├── currency_search_sheet.dart   # Searchable bottom sheet picker
    ├── result_card.dart             # Animated conversion result
    └── recent_conversions_panel.dart # Recent history list
```

---

## Setup



### Run

```bash
# Clone the repository
git clone <repo-url>
cd currency_canvas

# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Run on Chrome (web)
flutter run -d chrome

# Build APK
flutter build apk --release

# Build for Web
flutter build web
```

---

## Architecture

The app follows a clean, modular architecture:

- **Models** — Pure data classes with serialization
- **Services** — Business logic and API communication (no UI dependencies)
- **Widgets** — Reusable, composable UI components
- **Screens** — Page-level widgets that compose smaller widgets
- **Constants** — Theme, colors, and API configuration
- **Utils** — Stateless helper functions

---

## Design

- **Theme**: Dark Forest (#101817, #182422) + Copper (#D48A42) accent
- **Typography**: Google Fonts — Outfit
- **Cards**: Glassmorphism with backdrop blur and 24px radius
- **Buttons**: Copper gradient with press-to-scale micro-animation
- **Inputs**: Floating labels with copper focus highlight
- **Animations**: flutter_animate for staggered entrance effects

---

## License

MIT
