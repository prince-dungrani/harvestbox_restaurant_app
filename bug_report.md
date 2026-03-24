# HarvestBox — Bug Report & QA Documentation

## Bug Report Table

| Bug ID | Description | Steps to Reproduce | Severity | Status | Fix |
|--------|-------------|---------------------|----------|--------|-----|
| BUG-001 | **Cart total doesn't update on item removal** — When removing the last quantity of an item by decrementing, the total price briefly shows stale value | 1. Add item to cart 2. Go to Cart 3. Tap `-` to reduce to 0 4. Observe total | Medium | ✅ Fixed | `CartService.decrementItem()` now calls `notifyListeners()` before and after `removeItem()` to ensure UI rebuilds |
| BUG-002 | **App crashes when network image fails to load** — If an image URL returns 404, the app shows a grey box but sometimes throws an unhandled exception in debug mode | 1. Add a menu item with broken image URL 2. Navigate to Home Screen 3. Check debug console | Low | ✅ Fixed | Added `errorBuilder` to all `Image.network()` widgets to gracefully show a placeholder icon |
| BUG-003 | **Back button returns to Welcome Screen after login** — On Android, pressing the system back button from Home Screen navigates back to the Welcome/Login screen | 1. Login with email/password 2. Reach Home Screen 3. Press Android back button | High | ✅ Fixed | Wrapped login/home screens with `PopScope(canPop: false)` and used `Navigator.pushAndRemoveUntil()` to clear navigation stack |

---

## Common Flutter Debugging Tips

### 1. Using `flutter logs`
```bash
# View real-time device logs
flutter logs

# Filter logs for your app only
flutter logs | findstr "harvestbox"
```

### 2. Using Flutter DevTools
```bash
# Launch DevTools
flutter pub global activate devtools
dart devtools

# Or from VS Code: Ctrl+Shift+P → "Flutter: Open DevTools"
```

**Key DevTools tabs:**
- **Widget Inspector** — Explore widget tree, check layout constraints
- **Performance** — Profile frame rendering, find jank
- **Network** — Monitor HTTP requests (TheMealDB API calls)
- **Logging** — View `print()` statements and errors

### 3. Debug Print Statements
```dart
// Use debugPrint instead of print (handles long strings)
debugPrint('Cart items: ${cartService.items.length}');

// Conditional debug code
assert(() {
  debugPrint('Debug-only message');
  return true;
}());
```

### 4. Common Issues & Quick Fixes

| Issue | Fix |
|-------|-----|
| `setState() called after dispose()` | Check `if (mounted)` before `setState()` |
| Firebase not initialized | Ensure `await Firebase.initializeApp()` in `main()` |
| Image not loading | Check INTERNET permission in AndroidManifest.xml |
| Provider not found | Ensure `ChangeNotifierProvider` wraps the widget tree above the consumer |
| Hot reload not reflecting changes | Try `flutter clean && flutter pub get` |

---

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/cart_service_test.dart
flutter test test/login_screen_test.dart

# Run with verbose output
flutter test --reporter expanded

# Run with coverage
flutter test --coverage
```
