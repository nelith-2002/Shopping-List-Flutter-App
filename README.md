# Shopping List App 🛒

A feature-rich Flutter application for managing grocery shopping lists with real-time synchronization to Firebase backend.

## Features ✨

- **Add Items**: Easily add grocery items with quantity and category
- **Categorized Items**: Organize items by categories (Vegetables, Fruit, Meat, Dairy, Carbs, Sweets, Spices, Convenience, Hygiene, Other)
- **Search & Filter**: Real-time search functionality to quickly find items by name
- **Delete Items**: Swipe right to delete items with confirmation
- **Firebase Sync**: All data is synchronized with Firebase Realtime Database
- **Color-Coded Categories**: Each category has a distinct color for easy identification
- **Responsive UI**: Beautiful dark-themed UI with smooth animations
- **Real-time Updates**: Changes are reflected immediately across the app

## Screenshots 📱

The app features:

- **Main List Screen**: View all grocery items with quantities and color-coded categories
- **Search Bar**: Filter items by name in real-time
- **Add Item Dialog**: Create new items with quantity and category selection
- **Swipe to Delete**: Delete items with a simple swipe gesture

## Installation 🚀

### Prerequisites

- Flutter SDK (Version 3.0 or higher)
- Dart SDK (Version 2.18 or higher)
- Android Studio / Xcode (for mobile development)
- Firebase Account (free tier available)

### Setup Steps

1. **Clone the repository**

   ```bash
   git clone https://github.com/nelith-2002/Shopping-List-Flutter-App.git
   cd shopping_list_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Update the Firebase URL in these files:
     - `lib/widgets/grocery_list.dart`
     - `lib/widgets/new_item.dart`
   - Replace `shopping-list-flutter-ap-6e165-default-rtdb.firebaseio.com` with your Firebase Realtime Database URL

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure 📁

```
shopping_list_app/
├── lib/
│   ├── main.dart                 # App entry point and theme setup
│   ├── data/
│   │   ├── categories.dart       # Category definitions and mappings
│   │   └── dummy_items.dart      # Sample data (optional)
│   ├── models/
│   │   ├── category.dart         # Category model class
│   │   └── grocery_item.dart     # Grocery item model class
│   └── widgets/
│       ├── grocery_list.dart     # Main list screen with search
│       └── new_item.dart         # Add/edit item screen
├── test/
│   └── widget_test.dart          # Widget tests
├── pubspec.yaml                  # Project dependencies and metadata
├── analysis_options.yaml         # Dart analysis configuration
└── README.md                     # This file
```

## Key Files Overview 🔍

### `lib/main.dart`

Entry point of the application. Sets up the MaterialApp with dark theme and custom color scheme.

### `lib/widgets/grocery_list.dart`

Main screen displaying the grocery list with:

- FutureBuilder for async data loading
- Real-time search functionality
- Dismissible items for deletion
- Color-coded category indicators

### `lib/widgets/new_item.dart`

Add item screen with:

- Form validation
- Quantity input
- Category dropdown selector
- Firebase POST request for saving

### `lib/models/`

**grocery_item.dart**: Data class representing a single grocery item
**category.dart**: Data class for category with title and color

### `lib/data/categories.dart`

Centralized category definitions with color mappings

## Dependencies 📦

```yaml
dependencies:
  flutter: sdk: flutter
  http: ^1.0.0      # For HTTP requests to Firebase
```

See `pubspec.yaml` for the complete list of dependencies.

## Usage Guide 📖

### Adding an Item

1. Tap the **+** icon in the top-right of the app bar
2. Enter the item name (1-50 characters)
3. Enter the quantity (positive integer)
4. Select a category from the dropdown menu
5. Tap **Add Item** button to save

The item will be:

- Added to your local list immediately
- Sent to Firebase database
- Returned to the list screen automatically

### Searching for Items

1. Look for the search bar at the top of the list
2. Start typing the item name
3. Results filter in real-time as you type
4. Category color indicators remain visible for filtered items
5. Clear the search field to see all items again

### Deleting an Item

1. Find the item you want to delete
2. Swipe it from **right to left**
3. A red delete background appears
4. Release to confirm deletion
5. The item is removed from Firebase and the UI

### Categories 🏷️

Available categories with their color coding:

| Category    | Color        | Usage                 |
| ----------- | ------------ | --------------------- |
| Vegetables  | Bright Green | Fresh vegetables      |
| Fruit       | Yellow-Green | Fruits and berries    |
| Meat        | Orange       | Meat and poultry      |
| Dairy       | Cyan         | Milk, cheese, yogurt  |
| Carbs       | Blue         | Bread, pasta, rice    |
| Sweets      | Orange       | Candies, desserts     |
| Spices      | Amber        | Seasonings and spices |
| Convenience | Purple       | Pre-made foods        |
| Hygiene     | Purple       | Personal care items   |
| Other       | Cyan         | Miscellaneous items   |

## Firebase Configuration 🔧

This app uses Firebase Realtime Database for persistent cloud storage.

### Database Structure

The data is stored in the following JSON structure:

```json
{
  "shopping-list": {
    "item-id-1": {
      "name": "Milk",
      "quantity": 2,
      "category": "Dairy"
    },
    "item-id-2": {
      "name": "Bananas",
      "quantity": 5,
      "category": "Fruit"
    }
  }
}
```

### Setting Up Firebase

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use existing
3. Enable Realtime Database:
   - Click "Create Database"
   - Choose location
   - Start in test mode initially (for development)
4. Copy your Database URL and update in the code
5. Configure security rules

### Security Rules (for Production)

```json
{
  "rules": {
    "shopping-list": {
      ".read": "auth != null",
      ".write": "auth != null"
    }
  }
}
```

> ⚠️ **Important**: The above rules require Firebase Authentication. For development/testing, you can use more permissive rules, but always secure production databases.

## API Endpoints Used 📡

### Get Items

- **Endpoint**: `/shopping-list.json`
- **Method**: `GET`
- **Status Code**: 200 (success), 400+ (error)
- **Response**: JSON array of items

### Add Item

- **Endpoint**: `/shopping-list.json`
- **Method**: `POST`
- **Body**: `{name, quantity, category}`
- **Response**: `{name: "generated-id"}`

### Delete Item

- **Endpoint**: `/shopping-list/{item-id}.json`
- **Method**: `DELETE`
- **Status Code**: 200 (success), 400+ (error)

## Recent Improvements 🎯

### Bug Fixes

- ✅ Fixed Dismissible widget crashes when deleting items
- ✅ Fixed items not appearing immediately after adding
- ✅ Corrected unreachable catch block in async method
- ✅ Fixed misspelled variable `_enteredQuntity` → `_enteredQuantity`
- ✅ Removed dead code and incomplete widget assignments

### New Features

- ✅ Real-time search and filter functionality
- ✅ Enhanced user feedback with loading states
- ✅ Improved error messages
- ✅ Better state management for add/delete operations

## Troubleshooting 🔧

### Items not saving to Firebase

**Solution**:

- Verify Firebase URL is correct in the code
- Check Firebase database rules allow write access
- Ensure internet connection is active
- Check Firebase console for any errors

### Search not working

**Solution**:

- Clear the search field and try again
- Make sure items exist in the list
- Check that item names contain your search text
- Search is case-insensitive

### App crashes when deleting

**Solution**:

- Update to the latest version: `flutter upgrade`
- Clear build cache: `flutter clean`
- Rebuild: `flutter pub get` then `flutter run`
- Check that Firebase connection is stable

### Items appear then disappear

**Solution**:

- This happens when Firebase returns an error
- Check your database structure matches expected format
- Verify item category exists in categories.dart
- Check Firebase security rules

## Performance Tips ⚡

1. **Reduce List Size**: Archive old items periodically
2. **Optimize Search**: Search works client-side for fast filtering
3. **Firebase Indexes**: Create indexes for frequently filtered queries
4. **Cache Data**: Consider implementing local caching for offline support

## Testing 🧪

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Build and Deployment 🚀

### Build Android APK

```bash
flutter build apk --release
```

### Build iOS App

```bash
flutter build ios --release
```

### Build Web

```bash
flutter build web --release
```

## Contributing 🤝

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/AmazingFeature`
3. Commit your changes: `git commit -m 'Add AmazingFeature'`
4. Push to the branch: `git push origin feature/AmazingFeature`
5. Open a Pull Request

## Future Enhancements 🚀

- [ ] User authentication with Google/Email
- [ ] Category filtering and sorting
- [ ] Quantity checkmarks for bought items
- [ ] Shared shopping lists with family
- [ ] Price per item and total cost calculation
- [ ] Barcode scanning for quick item addition
- [ ] Theme customization (dark/light modes)
- [ ] Offline support with local database
- [ ] Item quantity history
- [ ] Export shopping list to PDF

## License 📄

This project is open source and available under the MIT License.

## Author 👨‍💻

**nelith-2002** - [GitHub Profile](https://github.com/nelith-2002)

## Support 💬

For issues, questions, or feature requests:

- Open an issue on [GitHub](https://github.com/nelith-2002/Shopping-List-Flutter-App/issues)
- Send a message or discussion on the repository

---

**Made with ❤️ using Flutter**

Happy Shopping! 🛍️
