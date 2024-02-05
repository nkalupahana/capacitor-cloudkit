import Foundation
import Capacitor
import SafariServices
import CloudKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CloudKitPlugin)
public class CloudKitPlugin: CAPPlugin {
    var safariVC: SFSafariViewController?;
    var lastCall: CAPPluginCall?;
    
    @objc func safariLogin(notification: Notification) {
        let url = notification.object as! URL;
        self.safariVC?.dismiss(animated: true)
        lastCall?.resolve([
            "ckWebAuthToken": url.query?.replacingOccurrences(of: "ckWebAuthToken=", with: "")
        ])
    }
    
    @objc func authenticate(_ call: CAPPluginCall) {
        lastCall = call;
        let url = "https://api.apple-cloudkit.com/database/1/\(call.getString("containerIdentifier") ?? "")/\(call.getString("environment") ?? "")/public/users/caller?ckAPIToken=\(call.getString("ckAPIToken") ?? "")"
        print(url)
        URLSession.shared.dataTask(with: URL(string: url)!) {(data, response, error) in
            guard let data = data else {
                call.reject("Invalid API token.");
                return;
            }
                        
            if let jdata = (try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)) as? [String : Any] {
                if let redirectURL = jdata["redirectURL"] as? String {
                    print(redirectURL);
                    self.safariVC = SFSafariViewController(url: URL(string: redirectURL)!);
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(CloudKitPlugin.safariLogin), name: Notification.Name("cloudkitLogin"), object: nil)
                    
                    DispatchQueue.main.sync {
                        self.bridge?.presentVC(self.safariVC!, animated: true, completion: {});
                    }
                    
                    return;
                }
            }
            
            call.reject("Invalid API response.");
        }.resume()
    }
    
    @objc func fetchRecord(_ call: CAPPluginCall) {
        let container = CKContainer(identifier: call.getString("containerIdentifier") ?? "");
        let databaseStr = call.getString("database") ?? "";
        var database: CKDatabase? = nil
        if databaseStr == "public" {
            database = container.publicCloudDatabase
        } else if databaseStr == "private" {
            database = container.privateCloudDatabase
        } else if databaseStr == "shared" {
            database = container.sharedCloudDatabase
        }
        
        if database == nil {
            return call.reject("Database value not valid!")
        }
        
        
        let recordBy = call.getString("by") ?? ""
        var recordID: CKRecord.ID? = nil
        if recordBy == "recordName" {
            recordID = CKRecord.ID(recordName: call.getString("recordName") ?? "")
        }
        
        if recordID == nil {
            return call.reject("Record fetch method (by) not specified!")
        }
        
        database!.fetch(withRecordID: recordID!) { record, err in
            if err != nil {
                return call.reject(err?.localizedDescription ?? "Record fetch error")
            }
            
            var res: [String: Any] = [:]
            if record == nil {
                return call.resolve(res)
            }

            for key in record!.allKeys() {
                if let value = record![key] {
                    res[key] = value
                }
            }
            
            call.resolve(res)
        }
    }
}
