import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // first things happens before the viewDidLoad loads up
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        // realm initialization
        do {
            _ = try Realm()
        } catch {
            print("error initialising new realm \(error)")
        }
        
        return true
    }
}

