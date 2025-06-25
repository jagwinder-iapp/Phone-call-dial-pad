//
//  AppDelegate.swift
//  DemoDialpad
//
//  Created by iapp on 18/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import UIKit
import PushKit
import CallKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: - Properties
    let callController = CXCallController()
    var voipRegistry = PKPushRegistry.init(queue: DispatchQueue.main)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkIfNotificationPermissionAuthorised { isGranted in
            if isGranted {
                self.voipRegistration()
            }
        }
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        print(#function)
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        NotificationCenter.default.post(name: .appWillTerminate,
                                        object: nil)
    }

    //MARK: - Permission Related Methods
    func requestForPushNotifications(completionHandler: ((Bool) -> Void)? = nil) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permission granted: \(granted)")
            completionHandler?(granted)
            if granted {
                self.getNotificationSettings()
            }
        }
        center.delegate = self
    }
    
    private func checkIfNotificationPermissionAuthorised(completionHandler: ((Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completionHandler?(settings.authorizationStatus == .authorized)
        }
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                self.voipRegistration()
            }
        }
    }
    
    // Register for VoIP notifications
    private func voipRegistration() {
        if voipRegistry.delegate == nil {
            // Set the registry's delegate to self
            voipRegistry.delegate = self
            // Set the push type to VoIP
            voipRegistry.desiredPushTypes = [PKPushType.voIP]
        }
    }
}

//MARK: - UNUserNotificationCenterDelegate
extension AppDelegate : UNUserNotificationCenterDelegate {
    //willPresent function gets callback when notification is received on app open
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        let userInfo = content.userInfo
        // let aps = userInfo["aps"] as? [String: Any]
        debugPrint("userInfo", userInfo)
        
        let infoRemote = userInfo as NSDictionary
        if let value1 = infoRemote["gcm.notification.key1"] as? NSString {
            debugPrint("value1",value1)
        }
        if let value2 = infoRemote["gcm.notification.key2"] as? NSString {
            debugPrint("value2",value2)
        }
        
        //perform your task here
    }
    
    ///didReceive function gets callback when app is opened from notification,
    ///but not on termiated state, for that `handleNotification` is called in `application(_, didFinishLaunchingWithOptions)`
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("response didReceive", response)
        
        let userInfo = response.notification.request.content.userInfo
        //perform your task here
        print("response didReceive, userInfo:", userInfo)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }
}

//MARK: - PKPushRegistryDelegate
extension AppDelegate: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print("\(#function); pushRegistry: \(registry);, didUpdate: \(credentials)")
        
        UserDefaults.voipTokenData = credentials.token
        let voipToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print("VoIP Token PKPushRegistry::", voipToken)
        UserDefaults.voipToken = voipToken
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print(#function)
    }
    
    //
    //when Incoming Calls are not getting
    // Check self.pushKitEventDelegate is assigning or not
    /**
     * Try using the `pushRegistry:didReceiveIncomingPushWithPayload:forType:withCompletionHandler:` method if
     * your application is targeting iOS 11. According to the docs, this delegate method is deprecated by Apple.
     * support iOS versions before iOS 11, this method will be triggered for compatibility.
     */
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        processVoIPPush(with: payload)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        processVoIPPush(with: payload)
        completion()
    }
    
    private func processVoIPPush(with payload: PKPushPayload) {
        // perform task on call received
    }
}
