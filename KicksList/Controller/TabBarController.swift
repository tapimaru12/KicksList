
import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        UITabBar.appearance().tintColor = .label
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 現在表示されているタブが再選択されるのを防ぐ
        if let selectedViewController = tabBarController.selectedViewController, selectedViewController == viewController {
            if let navigationController = viewController as? UINavigationController {
                // もしNavigationControllerがスタックを持っていれば一覧画面に戻す
                if navigationController.viewControllers.count > 1 {
                    navigationController.popToRootViewController(animated: true)
                    return false
                }
            }
            return false
        }
        // 通常のタブ選択処理
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController {
            if let kicksListCollectionVC = navigationController.topViewController as? KicksListCollectionViewController {
                kicksListCollectionVC.currentTab = tabBarController.selectedIndex
                kicksListCollectionVC.setData(tab: kicksListCollectionVC.currentTab)
            }
        }
    }
}
