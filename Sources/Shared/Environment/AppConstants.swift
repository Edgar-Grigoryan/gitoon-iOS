import Foundation
import KeychainAccess
import UIKit
import Version

/// Contains shared constants
public enum AppConstants {
    /// GiToon Blue
    public static var tintColor: UIColor {
        #if os(iOS)
        return UIColor { [lighterTintColor, darkerTintColor] (traitCollection: UITraitCollection) -> UIColor in
            traitCollection.userInterfaceStyle == .dark ? lighterTintColor : darkerTintColor
        }
        #else
        return lighterTintColor
        #endif
    }

    public static var lighterTintColor: UIColor {
        Asset.Colors.haPrimary.color
    }

    public static var darkerTintColor: UIColor {
        Asset.Colors.haPrimary.color
    }

    /// Help icon UIBarButtonItem
    #if os(iOS)
    public static var helpBarButtonItem: UIBarButtonItem {
        with(UIBarButtonItem(
            icon: .helpCircleOutlineIcon,
            target: nil,
            action: nil
        )) {
            $0.accessibilityLabel = L10n.helpLabel
        }
    }
    #endif

    /// The Bundle ID used for the AppGroupID
    public static var BundleID: String {
        let baseBundleID = Bundle.main.bundleIdentifier!
        var removeBundleSuffix = baseBundleID.replacingOccurrences(of: ".APNSAttachmentService", with: "")
        removeBundleSuffix = removeBundleSuffix.replacingOccurrences(of: ".Intents", with: "")
        removeBundleSuffix = removeBundleSuffix.replacingOccurrences(of: ".NotificationContentExtension", with: "")
        removeBundleSuffix = removeBundleSuffix.replacingOccurrences(of: ".TodayWidget", with: "")
        removeBundleSuffix = removeBundleSuffix.replacingOccurrences(of: ".watchkitapp.watchkitextension", with: "")
        removeBundleSuffix = removeBundleSuffix.replacingOccurrences(of: ".watchkitapp", with: "")
        removeBundleSuffix = removeBundleSuffix.replacingOccurrences(of: ".Widgets", with: "")
        removeBundleSuffix = removeBundleSuffix.replacingOccurrences(of: ".ShareExtension", with: "")
        removeBundleSuffix = removeBundleSuffix.replacingOccurrences(of: ".Matter", with: "")

        return removeBundleSuffix
    }

    public static var deeplinkURL: URL {
        switch Current.appConfiguration {
        case .debug:
            return URL(string: "homeassistant-dev://")!
        case .beta:
            return URL(string: "homeassistant-beta://")!
        default:
            return URL(string: "homeassistant://")!
        }
    }

    /// The App Group ID used by the app and extensions for sharing data.
    public static var AppGroupID: String {
        "group." + BundleID.lowercased()
    }

    public static var AppGroupContainer: URL {
        let fileManager = FileManager.default

        let groupDir = fileManager.containerURL(forSecurityApplicationGroupIdentifier: AppConstants.AppGroupID)

        guard let groupDir else {
            fatalError("Unable to get groupDir.")
        }

        return groupDir
    }

    public static var appGRDBFile: URL {
        let fileManager = FileManager.default
        let directoryURL = Self.AppGroupContainer.appendingPathComponent("databases", isDirectory: true)
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            } catch {
                Current.Log.error("Failed to create App GRDB file")
            }
        }
        let databaseURL = directoryURL.appendingPathComponent("App.sqlite")
        return databaseURL
    }

    public static var LogsDirectory: URL {
        let fileManager = FileManager.default
        let directoryURL = AppGroupContainer.appendingPathComponent("logs", isDirectory: true)

        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                fatalError("Error while attempting to create data store URL: \(error)")
            }
        }

        return directoryURL
    }

    /// An initialized Keychain from KeychainAccess.
    public static var Keychain: KeychainAccess.Keychain {
        KeychainAccess.Keychain(service: BundleID)
    }

    /// A permanent ID stored in UserDefaults and Keychain.
    public static var PermanentID: String {
        let storageKey = "deviceUID"
        let defaultsStore = UserDefaults(suiteName: AppConstants.AppGroupID)
        let keychain = KeychainAccess.Keychain(service: storageKey)

        if let keychainUID = keychain[storageKey] {
            return keychainUID
        }

        if let userDefaultsUID = defaultsStore?.object(forKey: storageKey) as? String {
            return userDefaultsUID
        }

        let newID = UUID().uuidString

        if keychain[storageKey] == nil {
            keychain[storageKey] = newID
        }

        if defaultsStore?.object(forKey: storageKey) == nil {
            defaultsStore?.setValue(newID, forKey: storageKey)
        }

        return newID
    }

    public static var build: String {
        SharedPlistFiles.Info.cfBundleVersion
    }

    public static var version: String {
        SharedPlistFiles.Info.cfBundleShortVersionString
    }

    static var clientVersion: Version {
        // swiftlint:disable:next force_try
        var clientVersion = try! Version(version)
        clientVersion.build = build
        return clientVersion
    }
}

public extension Version {
    static let canSendDeviceID: Version = .init(minor: 104)
    static let pedometerIconsAvailable: Version = .init(minor: 105)
    static let tagWebhookAvailable: Version = .init(minor: 114, prerelease: "b5")
    static let actionSyncing: Version = .init(minor: 115, prerelease: "any0")
    static let localPushConfirm: Version = .init(major: 2021, minor: 10, prerelease: "any0")
    static let externalBusCommandRestart: Version = .init(major: 2021, minor: 12, prerelease: "b6")
    static let updateLocationGPSOptional: Version = .init(major: 2022, minor: 2, prerelease: "any0")
    static let fullWebhookSecretKey: Version = .init(major: 2022, minor: 3)
    static let conversationWebhook: Version = .init(major: 2023, minor: 2, prerelease: "any0")
    static let externalBusCommandSidebar: Version = .init(major: 2023, minor: 4, prerelease: "b3")
    static let externalBusCommandAutomationEditor: Version = .init(major: 2024, minor: 2, prerelease: "any0")
    static let canUseAppThemeForStatusBar: Version = .init(major: 2024, minor: 7)

    var coreRequiredString: String {
        L10n.requiresVersion(String(format: "core-%d.%d", major, minor ?? -1))
    }
}
