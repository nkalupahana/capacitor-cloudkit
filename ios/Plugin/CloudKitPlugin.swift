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
                print("start")
                print(error)
                print(call.getString("ckAPIToken") ?? "")
                print("end")
                call.reject(error.localizedDescription)
            } else {
                let uriComponent = NSCharacterSet(charactersIn: ";,/?:@&=+$# ").inverted
                call.resolve([
                    "ckWebAuthToken": webToken!.addingPercentEncoding(withAllowedCharacters: uriComponent)!
                ])
            }
        }
        
        if #available(iOS 15.0, *) {
            operation.fetchWebAuthTokenResultBlock = { res in
                print(call.getString("ckAPIToken") ?? "")
                print(res)
            }
        } else {
            operation.fetchWebAuthTokenCompletionBlock = opClosure
        }
        
        operation.qualityOfService = .utility
        CKContainer(identifier: call.getString("containerIdentifier") ?? "").privateCloudDatabase.add(operation)
    }
}
