import Foundation
import RealmSwift

enum RealmProvider {
    static func config() -> Realm.Configuration {
        var config = Realm.Configuration(schemaVersion: 1)
        // Add migration blocks here when schema changes
        return config
    }

    static func realm() throws -> Realm {
        try Realm(configuration: config())
    }
}