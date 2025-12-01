# Biteful - Food Delivery App

## Overview

Biteful is a full-featured food delivery mobile application built with Flutter. This project demonstrates modern mobile development practices including state management, local database persistence, RESTful API integration, push notifications, and a polished user interface following Material Design 3 guidelines.

The app allows users to browse restaurants by category, view menus, add items to a cart, complete checkout with delivery/pickup options, track orders in real-time, and manage their profile settings including addresses and payment methods.

---

## Features

### Restaurant Browsing
- Home screen with horizontally scrollable category chips (Fast Food, Japanese, Pizza, Chinese, Mexican, Dessert, Healthy)
- Category pages displaying filtered restaurant listings
- Restaurant cards showing name, rating, delivery time, delivery fee, and distance
- High-quality food imagery from Unsplash

### Restaurant Details
- Hero image header with restaurant branding
- Delivery info card showing ETA, fees, rating, and distance
- Full menu display with item descriptions and prices
- Add to cart functionality with quantity selection

### Shopping Cart
- Real-time cart management with add/remove/update quantities
- Restaurant-specific cart (clears when switching restaurants)
- Itemized price breakdown with subtotal, taxes, and fees
- Persistent cart state using Provider

### Checkout Flow
- Delivery method selection (Delivery or Pickup)
- Delivery time selection (ASAP or scheduled)
- Address selection from saved addresses
- Payment method selection
- Order summary with final total
- Order confirmation with push notification

### Order Management
- Order history page showing all past orders
- Order details with itemized breakdown
- Order status tracking (Placed, Preparing, On the Way, Delivered)
- Real-time order tracking page with animated progress indicators
- Map placeholder for delivery tracking
- Clear order history functionality

### User Profile
- Editable saved addresses (add, edit, delete, set default)
- Editable payment methods (Visa, Mastercard, PayPal, Apple Pay)
- Notification preferences toggle
- Push notification testing
- Database reset option

### Notifications
- Local push notifications on order placement
- Notification permission handling
- Configurable notification preferences

---

## Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.9+ |
| Language | Dart 3.0+ |
| State Management | Provider |
| Navigation | GoRouter |
| Local Database | SQLite (sqflite) |
| HTTP Client | http package |
| Notifications | flutter_local_notifications |
| Permissions | permission_handler |
| Date Formatting | intl |
| Fonts | Google Fonts (Amiko, Mogra, Inter) |
| UI | Material Design 3 |

---

## Project Structure

```
lib/
├── data/
│   └── sample_data.dart       # Restaurant and menu data models
├── db/
│   └── database_helper.dart   # SQLite database operations
├── models/
│   ├── order.dart             # Order data model
│   └── order_item.dart        # Order item data model
├── pages/
│   ├── home_page.dart         # Main home screen
│   ├── category_page.dart     # Category filtered listings
│   ├── restaurant_page.dart   # Restaurant details and menu
│   ├── cart_page.dart         # Shopping cart
│   ├── checkout_page.dart     # Checkout flow
│   ├── payment_page.dart      # Payment processing
│   ├── orders_page.dart       # Order history
│   ├── track_page.dart        # Order tracking
│   ├── profile_page.dart      # User profile
│   ├── addresses_page.dart    # Address management
│   ├── payment_methods_page.dart # Payment method management
│   └── shell_home.dart        # Bottom navigation shell
├── providers/
│   └── cart_provider.dart     # Cart state management
├── services/
│   ├── api_service.dart       # HTTP API calls
│   └── notification_service.dart # Push notifications
├── widgets/
│   ├── category_chip.dart     # Category selection chips
│   └── restaurant_card.dart   # Restaurant display cards
├── main.dart                  # App entry point
├── router.dart                # GoRouter configuration
└── theme.dart                 # App theming and colors
```

---

## Getting Started

### Prerequisites

- Flutter SDK 3.9 or higher
- Dart SDK 3.0 or higher
- Xcode (for iOS development on macOS)
- Android Studio or VS Code with Flutter extensions
- iOS Simulator or Android Emulator with Android Studio

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd biteful-final
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

   To run on a specific device:
   ```bash
   flutter devices          # List available devices
   flutter run -d <device>  # Run on specific device
   ```

### First Launch

1. Grant notification permissions when prompted
2. The app will initialize the local SQLite database automatically
3. Browse restaurants and place an order to test the full flow

---

## API Integration

The app integrates with MockAPI.io for order management:

- **Base URL:** `https://692e04bae5f67cd80a4dab4e.mockapi.io`
- **POST /orders:** Create a new order
- **GET /orders:** Retrieve all orders

Restaurant data is loaded from local sample data for consistency and offline capability.

---

## Database Schema

### Orders Table
| Column | Type | Description |
|--------|------|-------------|
| id | TEXT | Primary key (UUID) |
| restaurantName | TEXT | Name of restaurant |
| status | TEXT | Order status |
| total | REAL | Order total |
| date | TEXT | ISO 8601 timestamp |

### Order Items Table
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key (auto-increment) |
| orderId | TEXT | Foreign key to orders |
| title | TEXT | Item name |
| price | REAL | Item price |
| quantity | INTEGER | Item quantity |

---

## Troubleshooting

**Blank screen on launch:**
```bash
flutter clean
flutter pub get
flutter run
```

**Notifications not appearing:**
- Ensure notification permissions are granted in device settings
- Use the "Test notification" button in Profile to verify

**Database errors:**
- Use "Reset Database" in Profile page
- Or reinstall the app to recreate the database

**Build errors:**
```bash
flutter clean
rm -rf ios/Pods ios/Podfile.lock
flutter pub get
cd ios && pod install && cd ..
flutter run
```

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.6.1
  provider: ^6.1.2
  google_fonts: ^6.2.1
  flutter_local_notifications: ^18.0.1
  permission_handler: ^11.3.1
  sqflite: ^2.4.1
  intl: ^0.19.0
  http: ^1.2.0
  path_provider: ^2.1.2
```

---

## License

This project is for educational purposes.
