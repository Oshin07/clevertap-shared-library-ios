import UIKit

/// Public API — the only class your clients ever interact with.
/// All events go to Account C. Their own CleverTap account is unaffected.
public class SharedEventTracker {

    // MARK: - Setup

    /// Call once in AppDelegate.application(_:didFinishLaunchingWithOptions:)
    /// - Parameters:
    ///   - launchOptions: Pass the launchOptions from AppDelegate directly
    ///   - sourceApp: A short name identifying this app (e.g. "Netflix-iOS")
    public static func initialize(
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
        sourceApp: String
    ) {
        CTInstanceManager.initialize(launchOptions: launchOptions, sourceApp: sourceApp)
    }

    /// Returns true if initialize() has been called
    public static func isInitialized() -> Bool {
        return CTInstanceManager.initialized
    }

    /// Returns the sourceApp name passed during initialization
    public static func getSourceApp() -> String {
        return CTInstanceManager.sourceApp
    }

    // MARK: - The 7 Predefined Events

    public static func trackHomeScreenViewed() {
        push(event: "Home Screen Viewed")
    }

    public static func trackContentPlayed(contentId: String, category: String) {
        push(event: "Content Played", props: [
            "Content ID": contentId,
            "Category": category
        ])
    }

    public static func trackUserRegistered(userId: String, method: String) {
        push(event: "User Registered", props: [
            "User ID": userId,
            "Registration Method": method
        ])
    }

    public static func trackSearchPerformed(
        query: String,
        resultCount: Int,
        filterApplied: String? = nil
    ) {
        var props: [String: Any] = [
            "Search Query": query,
            "Result Count": resultCount
        ]
        if let filter = filterApplied {
            props["Filter Applied"] = filter
        }
        push(event: "Search Performed", props: props)
    }

    public static func trackItemAddedToCart(
        itemId: String,
        itemName: String,
        price: Double
    ) {
        push(event: "Item Added to Cart", props: [
            "Item ID": itemId,
            "Item Name": itemName,
            "Price": price
        ])
    }

    public static func trackOrderPlaced(orderId: String, orderValue: Double) {
        push(event: "Order Placed", props: [
            "Order ID": orderId,
            "Order Value": orderValue
        ])
    }

    public static func trackFeatureDiscovered(featureName: String) {
        push(event: "Feature Discovered", props: [
            "Feature Name": featureName
        ])
    }

    // MARK: - Private

    private static func push(event: String, props: [String: Any] = [:]) {
        guard let ct = CTInstanceManager.instance else {
            print("[\(LibraryConfig.logTag)] Not initialized — call SharedEventTracker.initialize() in AppDelegate first.")
            return
        }
        var allProps = props
        allProps["source_app"] = CTInstanceManager.sourceApp
        ct.recordEvent(event, withProps: allProps)
    }
}
