import Foundation
import Capacitor
import CloudKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CloudKitPlugin)
public class CloudKitPlugin: CAPPlugin {
    private let implementation = CloudKit()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
        
    @objc func authenticate(_ call: CAPPluginCall) {
        let operation = CKFetchWebAuthTokenOperation(apiToken: call.getString("ckAPIToken") ?? "")
        let opClosure = { (webToken: String?, error: Error?) in
            if let error = error {
                call.reject(error.localizedDescription)
            } else {
                call.resolve([
                    "ckWebAuthToken": webToken!
                ])
            }
        }
        
        if #available(iOS 15.0, *) {
            operation.fetchWebAuthTokenCompletionBlock = opClosure
        } else {
            operation.fetchWebAuthTokenCompletionBlock = opClosure
        }
        
        operation.qualityOfService = .utility
        CKContainer.default().privateCloudDatabase.add(operation)
    }
}
