import Foundation
import CryptoKit

class RecoveryStorage {
    private static let ownerKey = "rideback_owner"
    private static let contactKey = "rideback_contact"
    private static let pinSaltKey = "rideback_pin_salt"
    private static let pinHashKey = "rideback_pin_hash"

    static var owner: String {
        get { UserDefaults.standard.string(forKey: ownerKey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: ownerKey) }
    }

    static var contact: String {
        get { UserDefaults.standard.string(forKey: contactKey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: contactKey) }
    }

    static func saveSettings(owner: String, contact: String, pin: String) -> Bool {
        guard !owner.trimmingCharacters(in: .whitespaces).isEmpty,
              contact.filter({ $0.isNumber }).count >= 7,
              pin.count >= 6, pin.allSatisfy({ $0.isNumber }) else {
            return false
        }

        self.owner = owner.trimmingCharacters(in: .whitespaces)
        self.contact = contact.trimmingCharacters(in: .whitespaces)

        // Generate Random Salt & Hash PIN
        let salt = UUID().uuidString
        let hashedPin = hashPin(pin, salt: salt)

        UserDefaults.standard.set(salt, forKey: pinSaltKey)
        UserDefaults.standard.set(hashedPin, forKey: pinHashKey)
        return true
    }

    static func verifyPin(_ pin: String) -> Bool {
        guard let salt = UserDefaults.standard.string(forKey: pinSaltKey),
              let expectedHash = UserDefaults.standard.string(forKey: pinHashKey) else {
            return false
        }
        return hashPin(pin, salt: salt) == expectedHash
    }

    private static func hashPin(_ pin: String, salt: String) -> String {
        let inputData = Data((pin + salt).utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
