@_implementationOnly import CleverTapSDK
import UIKit

// Internal — manages the library's own CleverTap instance pointing to Account C
internal class CTInstanceManager {

    static var instance: CleverTap?
    static var sourceApp: String = ""
    static var initialized: Bool = false

    static func initialize(launchOptions: [UIApplication.LaunchOptionsKey: Any]?, sourceApp: String) {
        guard !initialized else { return }

        self.sourceApp = sourceApp

        let config = CleverTapInstanceConfig(
            accountId: LibraryConfig.accountID,
            accountToken: LibraryConfig.accountToken
        )
        config.analyticsOnly = true

        instance = CleverTap.instance(with: config)

        // Belt-and-suspenders: explicitly block in-app display on the library's
        // secondary instance so no campaigns from Account C ever appear.
        instance?.suspendInAppNotifications()

        initialized = true

        print("[\(LibraryConfig.logTag)] Initialized for source_app='\(sourceApp)' → Account \(LibraryConfig.accountID)")
    }
}
