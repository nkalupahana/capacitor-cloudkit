import Foundation
import Capacitor
import SafariServices

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
}
