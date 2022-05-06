import Foundation

@objc public class CloudKit: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
