# NPT - Flutter App Drawer/Launcher

A powerful and modern Android app launcher built with Flutter 3.24.0, featuring a clean Material Design 3 interface, debounced search, and comprehensive app management capabilities.

## 🚀 Features

- **📱 Complete App Drawer**: Displays all installed Android applications with icons and names
- **🔍 Smart Search**: Debounced search functionality with 300ms delay for optimal performance
- **📊 Recent Apps**: Tracks and displays recently used applications
- **🎯 Performance Optimized**: Uses SliverGrid for smooth scrolling and minimal setState usage
- **🎨 Material Design 3**: Modern, clean, and responsive UI
- **⚡ Provider Pattern**: Efficient state management with minimal rebuilds
- **💾 Persistent Storage**: SharedPreferences for recent apps and search history
- **🏗️ Clean Architecture**: Well-organized folder structure and modular code

## 📁 Project Structure

```
npt/
├── lib/
│   ├── main.dart                     # App entry point
│   ├── models/
│   │   └── app_info.dart            # App information model
│   ├── providers/
│   │   ├── app_provider.dart        # App management state
│   │   └── search_provider.dart     # Search functionality state
│   ├── screens/
│   │   └── home_screen.dart         # Main app screen
│   ├── widgets/
│   │   ├── app_grid_widget.dart     # Performant app grid
│   │   ├── recent_apps_widget.dart  # Recent apps display
│   │   ├── search_bar_widget.dart   # Search input component
│   │   └── search_suggestions_widget.dart # Search suggestions
│   └── utils/
│       ├── debouncer.dart           # Search debouncing utility
│       └── storage_helper.dart      # SharedPreferences helper
├── android/
│   ├── app/
│   │   ├── build.gradle             # Android app configuration
│   │   ├── proguard-rules.pro       # ProGuard optimization rules
│   │   └── src/main/
│   │       ├── AndroidManifest.xml  # App permissions & configuration
│   │       └── kotlin/com/example/npt/
│   │           └── MainActivity.kt   # Android main activity
│   ├── build.gradle                 # Root build configuration
│   ├── gradle.properties            # Gradle settings (CI optimized)
│   └── settings.gradle              # Gradle project settings
├── test/
│   └── widget_test.dart             # Unit and widget tests
├── .github/
│   └── workflows/
│       └── ci-cd.yml                # GitHub Actions CI/CD pipeline
└── pubspec.yaml                     # Flutter dependencies
```

## 🛠️ Technical Specifications

- **Flutter Version**: 3.24.0 stable
- **Dart SDK**: >=3.3.0 <4.0.0
- **Android minSdkVersion**: 23 (Android 6.0)
- **State Management**: Provider pattern
- **Architecture**: Clean architecture with separation of concerns
- **Search Debouncing**: 300ms delay for optimal performance
- **Grid Performance**: SliverGrid for efficient scrolling

## 📦 Dependencies

### Main Dependencies
- `provider: ^6.1.2` - State management
- `device_apps: ^2.2.0` - Access installed Android apps
- `package_info_plus: ^8.0.0` - App package information
- `shared_preferences: ^2.2.3` - Persistent local storage
- `collection: ^1.18.0` - Collection utilities

### Development Dependencies
- `flutter_test` - Testing framework
- `flutter_lints: ^4.0.0` - Dart linting rules
- `test: ^1.25.2` - Unit testing

## 🚦 Getting Started

### Prerequisites
- Flutter SDK 3.24.0 or higher
- Android SDK with API level 23+
- Java 17 for building

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd npt
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Build and run**
   ```bash
   # Debug build
   flutter run
   
   # Release build
   flutter build apk --release
   ```

## 🏗️ Build Configuration

### Android Configuration
- **Package Name**: `com.example.npt`
- **Permissions**: QUERY_ALL_PACKAGES, GET_PACKAGE_SIZE, INTERNET, WAKE_LOCK
- **Gradle**: Configured for CI stability with daemon=false and parallel=false
- **ProGuard**: Optimized for release builds with code obfuscation

### Gradle Settings (CI Optimized)
```properties
org.gradle.daemon=false
org.gradle.parallel=false
org.gradle.configuration-cache=true
android.useAndroidX=true
```

## 🧪 Testing

The project includes comprehensive testing:

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test files
flutter test test/widget_test.dart
```

## 🚀 CI/CD Pipeline

### GitHub Actions Workflow Features

- **✅ Code Quality**: Flutter analyze and Dart formatting checks
- **🧪 Testing**: Unit and widget tests with coverage reporting
- **🏗️ Build**: Android APK build with retry logic
- **📏 Performance**: APK size measurement and performance rating
- **🔒 Security**: Configuration validation and dependency checks
- **📦 Artifacts**: Automated artifact uploads with 30-day retention
- **🚀 Release**: Automated releases on main branch merges

### Performance Ratings
- **🌟 Excellent**: <10MB APK size
- **👍 Good**: <25MB APK size
- **⚠️ Average**: <50MB APK size
- **🚨 Large**: >50MB APK size

### Build Retry Logic
The CI pipeline includes intelligent retry logic:
1. Run `flutter clean` and `flutter pub get` between retries
2. Maximum 3 build attempts with exponential backoff
3. Detailed logging for debugging build failures

## 📱 App Functionality

### Core Features

1. **App Discovery**: Automatically detects all installed apps
2. **Search**: Real-time search with debouncing for performance
3. **Recent Apps**: Tracks frequently used applications
4. **App Launch**: Direct app launching via package names
5. **Settings**: Toggle system apps, adjust grid columns

### UI Components

- **App Grid**: Performant SliverGrid with circular icons
- **Search Bar**: Material Design 3 styled search input
- **Recent Apps**: Horizontal scrolling recent apps list
- **Settings**: Bottom sheet with app preferences

## 🔧 Configuration

### Customization Options

- **Grid Columns**: 2-6 columns (default: 4)
- **System Apps**: Show/hide system applications
- **Search History**: Persistent search term storage
- **Recent Apps**: Track up to 10 recent applications

### Storage

The app uses SharedPreferences for:
- Recent apps list (max 10 items)
- Search history (max 20 items)
- User preferences (grid columns, system apps visibility)

## 🐛 Troubleshooting

### Common Issues

1. **Apps not loading**: Ensure QUERY_ALL_PACKAGES permission is granted
2. **Search not working**: Check device_apps plugin compatibility
3. **Build failures**: Run `flutter clean && flutter pub get`

### Debug Mode
```bash
flutter run --debug --verbose
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `flutter test`
5. Run linting: `flutter analyze`
6. Format code: `dart format .`
7. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🔗 References

- **Flutter Documentation**: https://docs.flutter.dev/
- **Material Design 3**: https://m3.material.io/
- **Provider Pattern**: https://pub.dev/packages/provider
- **Device Apps Plugin**: https://pub.dev/packages/device_apps

## 💡 Future Enhancements

- [ ] App categories and folders
- [ ] Custom themes and wallpapers
- [ ] Widget support
- [ ] App shortcuts and actions
- [ ] Backup and restore functionality
- [ ] Advanced search filters

---

**Built with ❤️ using Flutter 3.24.0** 