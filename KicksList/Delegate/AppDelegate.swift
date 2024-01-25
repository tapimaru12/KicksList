
import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Realm migration
        let config = Realm.Configuration(
            schemaVersion: 1, // schemaVersionを0から1に増加。
            migrationBlock: { migration, oldSchemaVersion in
                // 設定前のschemaVersionが最新の数値より小さい場合、マイグレーションを実行。
                if oldSchemaVersion < 1 {
                    migration.renameProperty(onType: NowKicksDataModel.className(), from: "purchaseStore", to: "purchaseLocation")
                    migration.renameProperty(onType: PastKicksDataModel.className(), from: "purchaseStore", to: "purchaseLocation")
                }
            })
        Realm.Configuration.defaultConfiguration = config
        
        // スプラッシュ画面を表示する秒数
        sleep(1)
        // NavigationBarButtonItemの色を黒色に変更
        UINavigationBar.appearance().tintColor = .label
        
        // NavigationBarの下線を消す
        let navigationBarAppearance = UINavigationBarAppearance()
//        appearance.configureWithDefaultBackground()
//        appearance.shadowImage = UIImage()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backgroundColor = .systemBackground
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

