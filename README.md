#   Specialty Coffee ركن القهوه

<img src="assets/images/readmepic.png" alt="Coffee Shop App" width="480" />

A specialty coffee shop app built with **Flutter**, featuring an animated intro (splash) screen and a live drink menu loaded from a remote API. Designed with a warm, professional coffee-shop visual theme using a shared color palette, Google Fonts, and custom painters.

---

## ✨ Features

- **Animated Intro Page** — A roastery "label" poster: coffee-bag hero inside an arched window, a rotating wax-seal stamp biting into the paper card, a halftone/sunburst printed backdrop, staggered entrance animations, brand title, tagline, and navigation buttons leading to the menu.
- **Live Menu** — Drinks fetched remotely (`/api/coffee/v1/drinks?type=hot`) and displayed in a 2-column card grid.
- **Product Details Page** — Tapping any drink opens a full-screen page with its tasting note, price in EGP, a quantity selector, and an **Add to Cart** action.
- **Shopping Cart** — A `CartCubit` shared above the Navigator keeps the item count and EGP total; a badge in the menu header shows the live count and opens the **Cart page**, which lists every line with a quantity stepper, the EGP subtotal/total, a clear-all action, and checkout.
- **Order Notifications (FCM)** — Checkout pops a confirmation dialog (*"تم استلام طلبك — order ready to be prepared"*) plus a receipt snackbar, and posts the order to `backend/`, which pushes a **Firebase Cloud Messaging** notification to the phone (system tray in the background, `flutter_local_notifications` while the app is open).
- **Clean Architecture** — Strict separation of `data`, `domain`, and `presentation` layers with repositories, use cases, and Cubit state management.
- **Coffee Shop Theme** — Consistent rust & butter palette defined in `AppColors` and `AppTheme`, with `Cairo`, `Caveat`, and `Special Elite` Google Fonts.
- **Custom Painters** — Hand-drawn espresso machine, stamp borders, doodles, and background decorations.
- **Loading & Error States** — Animated "energy loading" poster while fetching, plus a retry flow on failure.


## 🏗 Architecture

```
lib/
├── main.dart                          # App entry point (FCM init → IntroPage → MenuPage)
├── core/
│   ├── network/dio_client.dart        # Dio HTTP client (funapi.dev)
│   ├── notifications/fcm_service.dart # Firebase Cloud Messaging bootstrap
│   ├── theme/
│   │   ├── app_colors.dart            # Coffee-shop color palette
│   │   └── app_theme.dart             # Material 3 ThemeData
│   └── usecases/usecase.dart          # Base use case contract
└── features/
    ├── menu/
    │   ├── data/
    │   │   ├── datasources/remote.dart    # Remote coffee data source
    │   │   ├── drink_catalog.dart         # Hardcoded EGP prices + notes
    │   │   ├── models/coffe_model.dart    # JSON model
    │   │   └── repositories/coffe_imp.dart# Repository implementation
    │   ├── domain/
    │   │   ├── entities/coffe.dart        # Coffee entity (incl. priceEgp)
    │   │   ├── repositories/coffee_repo.dart # Repository contract
    │   │   └── usecases/use.dart          # GetHotCoffee use case
    │   └── presentation/
    │       ├── cubic/                     # CoffeeCubit + CoffeeState
    │       ├── pages/                     # intro, menu, product_details
    │       └── widgets/                   # posters, painters, cart badge
    └── cart/
        ├── domain/
        │   ├── entities/
        │   │   ├── cart_item.dart         # Coffee + quantity line item
        │   │   └── order_draft.dart       # Checkout snapshot (sent to backend)
        │   └── repositories/order_repository.dart # Order contract
        ├── data/
        │   ├── datasources/order_remote.dart      # POST /api/orders
        │   └── repositories/order_repository_impl.dart
        └── presentation/
            ├── cubic/                     # CartCubit + CartState
            ├── cart_navigator.dart        # openCartPage helper
            └── pages/cart_page.dart       # cart lines, totals, checkout
backend/
├── server.js                         # Express + firebase-admin order endpoint
└── README.md                         # Service-account & run instructions
```

**State flow:** `Page` → `Cubit` → `UseCase` → `Repository` → `DataSource` → `Dio`

---

## 🔔 Order notifications (FCM)

```
checkout tap ──► OrderDraft (snapshot) ──► CartCubit.placeOrder
                        │                        │ POST /api/orders
                        ▼                        ▼
              confirmation dialog          backend/ (trusted)
              + receipt snackbar           holds the FCM server key
                                                   │ send()
                                                   ▼
                                     device system notification
                                     "طلبك جاهز للتحضير"
```

The app never holds the FCM server key — it only holds a device token.

1. **App** — `FcmService.init()` (called before `runApp`) requests
   notification permission, creates the `order_updates` channel, keeps the
   device token and renders messages that arrive while the app is open.
2. **Backend** (`backend/`) — Express + `firebase-admin` service that turns
   `POST /api/orders` into the push. Setup is in [`backend/README.md`](backend/README.md).
3. **Point the app at it** with `--dart-define=ORDER_API_BASE=…`
   (defaults to `http://10.0.2.2:8080`, the host machine from the emulator).

Firebase project: `coffee-shop-roknn` (config in `lib/firebase_options.dart`,
Android app id `com.roknn.coffee_shop_app`).

---

## 🎨 Theme

The palette is a **rust & butter** scheme sampled from the reference cup
artwork — a warm rust-brown frame, pale butter-yellow sheets, golden accents
and warm white highlights. Every screen reads its colors from `AppColors`, so
retinting the whole app is a matter of editing that one file.

| Token | Hex | Usage |
|-------|-----|-------|
| `darkEspresso` | `#8C4527` | Rust frame, primary text & filled buttons |
| `pastelPink` | `#F3DB96` | Golden accent — CTAs, price chips |
| `powderBlue` | `#FBF6E6` | Warm white — poster, on-dark outlines |
| `creamPaper` | `#F8F0C6` | Pale butter sheets & light text on rust |
| `warmCream` | `#F1E7A9` | Deeper butter for tiles, notes & chips |
| `darkInk` | `#4E2313` | Deepest roast — strongest contrast |

Fonts: **Cairo** (primary/UI), **Caveat** (display), **Special Elite** (labels).

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Dart `^3.8.1`)
- An IDE (VS Code / Android Studio)
- Node.js 18+ — only needed for the FCM order backend
- An Android device/emulator running API 24 or newer (Firebase requirement)

### Installation

```bash
flutter pub get
flutter run                                   # the app
cd backend && npm install && npm start        # FCM order notifications
```

The app talks to the backend at `http://10.0.2.2:8080` (your machine seen
from the Android emulator). Override it for a physical device:

```bash
flutter run --dart-define=ORDER_API_BASE=http://192.168.1.10:8080
```

### Run tests

```bash
flutter test
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
| `firebase_core` | Firebase bootstrap (`lib/firebase_options.dart`) |
| `firebase_messaging` | FCM device token + incoming pushes |
| `flutter_local_notifications` | Shows FCM messages while the app is open |

The backend in `backend/` is plain Node: `express`, `cors`, `firebase-admin`.

---

## 🖼 Assets

Located in `assets/images/`:

- `readmepic.png` — README cover image
- `coffee-bag.png` — Intro page hero image
- `coffee-beans.png` — Menu page header logo

---

