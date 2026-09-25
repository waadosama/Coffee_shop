#   Specialty Coffee ركن القهوه

<img src="assets/images/readmepic.png" alt="Coffee Shop App" width="480" />

A specialty coffee shop app built with **Flutter**, featuring an animated intro (splash) screen and a live drink menu loaded from a remote API. Designed with a warm, professional coffee-shop visual theme using a shared color palette, Google Fonts, and custom painters.

---

## ✨ Features

- **Animated Intro Page** — Centered coffee-bag hero image with staggered entrance animations, brand title, tagline, and navigation buttons leading to the menu.
- **Live Menu** — Drinks fetched remotely (`/api/coffee/v1/drinks?type=hot`) and displayed in a 2-column card grid.
- **Clean Architecture** — Strict separation of `data`, `domain`, and `presentation` layers with repositories, use cases, and Cubit state management.
- **Coffee Shop Theme** — Consistent espresso/pink/blue/cream palette defined in `AppColors` and `AppTheme`, with `Cairo`, `Caveat`, and `Special Elite` Google Fonts.
- **Custom Painters** — Hand-drawn espresso machine, stamp borders, doodles, and background decorations.
- **Loading & Error States** — Animated "energy loading" poster while fetching, plus a retry flow on failure.


## 🏗 Architecture

```
lib/
├── main.dart                          # App entry point (IntroPage → MenuPage)
├── core/
│   ├── network/dio_client.dart        # Dio HTTP client (funapi.dev)
│   ├── theme/
│   │   ├── app_colors.dart            # Coffee-shop color palette
│   │   └── app_theme.dart             # Material 3 ThemeData
│   └── usecases/usecase.dart          # Base use case contract
└── features/menu/
    ├── data/
    │   ├── datasources/remote.dart    # Remote coffee data source
    │   ├── models/coffe_model.dart    # JSON model
    │   └── repositories/coffe_imp.dart# Repository implementation
    ├── domain/
    │   ├── entities/coffe.dart        # Coffee entity
    │   ├── repositories/coffee_repo.dart # Repository contract
    │   └── usecases/use.dart          # GetHotCoffee use case
    └── presentation/
        ├── cubic/                     # CoffeeCubit + CoffeeState
        ├── pages/                     # intro_page, menu_page
        └── widgets/                   # posters, painters, intro widgets
```

**State flow:** `Page` → `Cubit` → `UseCase` → `Repository` → `DataSource` → `Dio`

---

## 🎨 Theme

| Token | Hex | Usage |
|-------|-----|-------|
| `darkEspresso` | `#422E27` | Primary backgrounds & text |
| `pastelPink` | `#EAD2DA` | Accent, buttons, brand name |
| `powderBlue` | `#AAC0CF` | Secondary accent |
| `creamPaper` | `#F2EADD` | Surfaces & cards |
| `darkInk` | `#2E1E1A` | Deep contrast |

Fonts: **Cairo** (primary/UI), **Caveat** (display), **Special Elite** (labels).

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Dart `^3.8.1`)
- An IDE (VS Code / Android Studio)

### Installation

```bash
flutter pub get
flutter run
```

### Run analysis

```bash
flutter analyze
```

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `dio` | HTTP networking |
| `flutter_bloc` | Cubit state management |
| `google_fonts` | Cairo / Caveat / Special Elite fonts |
| `equatable` | Value equality |
| `flutter_riverpod` | DI (available) |
| `cupertino_icons` | iOS-style icons |

---

## 🖼 Assets

Located in `assets/images/`:

- `readmepic.png` — README cover image
- `coffee-bag.png` — Intro page hero image
- `coffee-beans.png` — Menu page header logo

---

