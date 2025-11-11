# 🍔 Biteful - Food Delivery App (made w GPT for now)

A modern, beautiful food delivery application built with Flutter. Browse restaurants, order food, track deliveries, and manage your orders with a smooth, intuitive interface.

![Flutter](https://img.shields.io/badge/Flutter-3.9+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)

## ✨ Features (need polishing)

- 🏪 **Browse Restaurants** - Explore various restaurants with ratings and delivery info
- 🍕 **Menu Navigation** - View detailed menus with appetizers, mains, and drinks
- 🛒 **Shopping Cart** - Add items to cart with quantity management
- 💳 **Checkout Flow** - Choose delivery method and place orders & time.
- 📦 **Order Tracking** - Track your orders with detailed status updates
- 📱 **Order History** - View all past orders with full details
- 🔔 **Push Notifications** - Get notified when orders are placed
- 👤 **User Profile** - Manage notification preferences and settings
- 🎨 **Modern UI** - Beautiful Material Design 3 interface with custom theming

## 📱 Screenshots

*(Add screenshots here once you have them)*

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9 or higher)
- Dart SDK (3.0 or higher)
- iOS Simulator (Mac) or Android Emulator
- Xcode (for iOS development on Mac)
- Android Studio or VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/biteful-app.git
   cd biteful-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   
   **iOS (Mac only):**
   ```bash
   flutter run
   ```
   
   **Android:**
   ```bash
   flutter run
   ```
   
   **Specific device:**
   ```bash
   flutter devices  # List available devices
   flutter run -d <device-id>
   ```

### First Run

On first launch:
1. Grant notification permissions when prompted
2. The app will initialize the local database
3. Browse sample restaurants and place your first order!

## 🏗️ Project Structure

```
lib/
├── data/           # Sample data and models
├── db/             # SQLite database helper
├── models/         # Data models (Order, OrderItem)
├── pages/          # All app screens
├── providers/      # State management (Cart)
├── services/       # Notification service
├── widgets/        # Reusable UI components
├── main.dart       # App entry point
├── router.dart     # Navigation configuration
└── theme.dart      # App theming
```

## 🛠️ Tech Stack

- **Framework:** Flutter 3.9+
- **Language:** Dart 3.0+
- **State Management:** Provider
- **Navigation:** GoRouter
- **Local Database:** SQLite (sqflite)
- **Notifications:** flutter_local_notifications
- **UI Components:** Material Design 3
- **Fonts:** Google Fonts (Amiko, Mogra, Inter)

## 📦 Key Dependencies

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
  flutter_svg: ^2.0.10+1
```

## 🎨 Features in Detail

### Restaurant Browsing
- Grid layout with restaurant cards
- Rating system with star display
- Delivery time and fee information
- Distance calculation

### Cart Management
- Add/remove items with quantity control
- Restaurant-specific cart (prevents mixing orders)
- Real-time total calculation with taxes
- Persistent cart state

### Order System
- SQLite database for order persistence
- Order status tracking (Placed, Delivery, Pickup)
- Order history with full details
- Clear all orders functionality

### Notifications
- Local push notifications
- Order confirmation alerts
- Customizable notification preferences
- Test notification feature

## 🔧 Configuration

### iOS Setup
Notifications are pre-configured in `ios/Runner/Info.plist` with:
- Alert permissions
- Badge permissions
- Sound permissions
- Background modes

### Android Setup
No additional configuration needed. Notification channels are automatically created.

## 🐛 Troubleshooting

**App shows blank screen on launch:**
- Make sure to run `flutter clean` and `flutter pub get`
- Restart the simulator/emulator

**Notifications not appearing:**
- Grant notification permissions in system settings
- Try the "Test notification" button in Profile → Notifications

**Database errors:**
- Use the "Reset Database" button in Profile page
- Or reinstall the app to recreate the database

**Build errors:**
```bash
flutter clean
flutter pub get
flutter run
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Your Name**
- GitHub: [@YOUR_USERNAME](https://github.com/YOUR_USERNAME)

## 🙏 Acknowledgments

- Restaurant images from sample data
- Icons from Material Design
- Fonts from Google Fonts
- Flutter team for the amazing framework

---

Made with ❤️ and Flutter
