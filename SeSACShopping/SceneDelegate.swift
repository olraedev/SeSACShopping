//
//  SceneDelegate.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/18/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        localNotificationToUser()
        
        UINavigationBar.appearance().tintColor = ColorDesign.text.fill
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
        window = UIWindow(windowScene: scene)
        
        let nickname = UserDefaultsManager.shared.getStringValue(.nickname)
        let profile = UserDefaultsManager.shared.getStringValue(.profile)
        
        if nickname == "" || profile == "" {
            let nav = UINavigationController(rootViewController: OnboardViewController())
            
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    func localNotificationToUser() {
        let content = UNMutableNotificationContent()
        content.title = "까먹으셨죠?"
        content.body = "하루에 한번 쇼핑 리스트 관리해주셔야죠!"
        content.badge = 1
        
        var component = DateComponents()
        component.hour = 20
        component.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
        let request = UNNotificationRequest(identifier: "\(Date())", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
