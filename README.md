# Shopsy

Shopsy is a simple e-commerce sample app built with Flutter showcasing a clean MVVM architecture and adherence to SOLID principles. It demonstrates product listing, search, product detail, and a persistent cart using `provider` for state management.

## Table of Contents
- Features
- Architecture (MVVM + Clean)
- SOLID in practice
- Project structure
- Key components
- Tech stack
- Running locally
- Building APK/IPA
- Download APK
- Tests

## Features
- Product list with search
- Product detail view
- Add/remove/update items in cart
- Cart persists using SharedPreferences
- Light/Dark themes with Material 3 and Inter font

## Architecture (MVVM + Clean)
The app follows a clean MVVM separation of concerns:

- Presentation: Views (Flutter UI) and ViewModels (`ChangeNotifier`) to manage UI state and expose actions.
- Domain: Business logic in small use cases and repository interfaces (contracts).
- Data: Concrete implementations that access assets and local storage.

This separation ensures that the UI depends only on the domain layer (use cases), not on concrete data sources. Swapping or extending data sources does not affect UI/ViewModels.

## SOLID in practice
- Single Responsibility: Each class has one reason to change (e.g., `GetProducts` only fetches products, `PersistCart` only persists cart quantities).
- Open/Closed: Add new data sources by creating new repository implementations without modifying consumers.
- Liskov Substitution: ViewModels depend on repository interfaces; any implementation that respects the contract can be substituted.
- Interface Segregation: Small, focused interfaces (`IProductRepository`, `ICartStorage`).
- Dependency Inversion: Presentation depends on abstractions (use cases, interfaces), not concretions.

## Project structure
```
lib/
  app/
    app.dart                // MaterialApp, themes, navigation setup
    routes.dart             // Centralized route generation
  data/
    cart_storage.dart       // CartStorageImpl (SharedPreferences)
    product_repository.dart // ProductRepositoryImpl (assets JSON)
  domain/
    repositories/
      cart_storage.dart     // ICartStorage
      product_repository.dart // IProductRepository
    usecases/
      clear_cart.dart       // Clear cart persistence
      get_products.dart     // Fetch products
      hydrate_cart.dart     // Build in-memory cart from persisted quantities
      persist_cart.dart     // Persist in-memory cart quantities
      search_products.dart  // Pure in-memory search
  models/
    product.dart
    cart_item.dart
  viewmodels/
    product_list_view_model.dart
    cart_view_model.dart
  views/
    product_list/
      product_list_screen.dart
    product_detail/
      product_detail_screen.dart
    cart/
      cart_screen.dart
```

## Key components
- Views: Stateless UI widgets that observe ViewModels via `provider`.
- ViewModels: `ChangeNotifier` classes that expose state and delegate work to use cases.
- Use cases: Small, composable classes in `lib/domain/usecases` encapsulating one domain action.
- Repositories (interfaces): Contracts in `lib/domain/repositories`.
- Data implementations: Concrete classes in `lib/data` fulfilling repository contracts.

## Tech stack
- Flutter (Material 3)
- Provider (state management and DI)
- SharedPreferences (local persistence)
- Google Fonts (Inter)

## Download APK
- Latest release APK: [Download Shopsy APK]([https://example.com/shopsy-latest.apk](https://drive.google.com/file/d/1hpJt8cZlfkW2nHbVFSdhZ0cR3dEDryS1/view?usp=sharing))

