# SharedEventLib — iOS

A shared analytics library built on CleverTap SDK. Tracks 7 predefined business events across all apps in a portfolio, sending data to a single dedicated CleverTap account.

## What It Does

- Exposes a simple API — app teams call predefined methods, no CleverTap knowledge needed
- All events go to a central CleverTap account (Account C), separate from any account the app already uses
- Does not interfere with existing CleverTap setup in the host app
- In-app campaigns and push from Account C are disabled by design

## Events

| Method | Event Name | Properties |
|---|---|---|
| `trackHomeScreenViewed()` | Home Screen Viewed | — |
| `trackContentPlayed(contentId:category:)` | Content Played | Content ID, Category |
| `trackUserRegistered(userId:method:)` | User Registered | User ID, Registration Method |
| `trackSearchPerformed(query:resultCount:)` | Search Performed | Query, Result Count, Filter Applied |
| `trackItemAddedToCart(itemId:itemName:price:)` | Item Added to Cart | Item ID, Item Name, Price |
| `trackOrderPlaced(orderId:orderValue:)` | Order Placed | Order ID, Order Value |
| `trackFeatureDiscovered(featureName:)` | Feature Discovered | Feature Name |

Every event automatically includes `source_app` identifying which app fired it.

## Integration — Swift Package Manager

### Step 1 — Add the package

In Xcode: **File → Add Package Dependencies** → paste:
```
https://github.com/YOUR_USERNAME/clevertap-shared-library-ios
```
Select version `1.0.0` or **Up to Next Major**.

### Step 2 — Initialise in AppDelegate

```swift
import SharedEventLib

func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Call after CleverTap.autoIntegrate() if your app uses CleverTap
    SharedEventTracker.initialize(launchOptions: launchOptions, sourceApp: "YourAppName-iOS")
    return true
}
```

### Step 3 — Track events

```swift
SharedEventTracker.trackHomeScreenViewed()
SharedEventTracker.trackOrderPlaced(orderId: "ORD-001", orderValue: 99.99)
```

## Requirements

- iOS 13 or later
- No CleverTap credentials needed — everything is bundled inside the library
