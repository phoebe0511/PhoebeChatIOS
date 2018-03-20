//
//  AppDelegate.swift
//  PhoebeChat
//
//  Created by Hsiu Ping Lin on 2018/3/14.
//  Copyright © 2018年 Hsiu Ping Lin. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications
import FirebaseMessaging
import FirebaseInstanceID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    let DATABASE_REF_NAME = "UserProfile"
    var userArray : [UserProfile] = [UserProfile]()
    var fcmToken = ""
    var hasToken = false
    var observeWithValueHandler : UInt = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
            if error == nil{
                print("**** requestAuthorization done!")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    //NotificationCenter.default.addObserver(self, selector: #selector(self.gotToken) , name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
                    Messaging.messaging().delegate = self
                }
            }
        }
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
   
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "PhoebeChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("~~~~~~~~~~~~~~~~~~`didReceiveRegistrationToken token=\(String(describing: fcmToken))")
        self.fcmToken = fcmToken
    }
    
    func receiveFirebaseDB(){
        //PushNotification.saveToken(str: token!)
        let userDB = Database.database().reference().child(DATABASE_REF_NAME)

        observeWithValueHandler = userDB.observe(.value) { (datasnapshot) in
            //print(datasnapshot.value)
            if datasnapshot.value != nil{
                for snapshot in datasnapshot.children{
                    let datass = snapshot as! DataSnapshot
                    let snapshotValue = datass.value as! Dictionary<String, String>
                    print(snapshotValue)
                    let text = snapshotValue["Token"]!
                    let sender = snapshotValue["Sender"]!
                    //print(sender, text)
                    let user = UserProfile()
                    user.sender = sender
                    user.notificationId = text
                    self.userArray.append(user)
                    if self.fcmToken == text{
                        self.hasToken = true
                    }
                }
                if self.hasToken == false{
                    self.saveToken()
                }
                userDB.removeObserver(withHandle: self.observeWithValueHandler)
            }
        }

    }
    
    func saveToken(){
        let userDB = Database.database().reference().child(DATABASE_REF_NAME)
        let dictionary = ["Sender" : Auth.auth().currentUser?.email, "Token" : fcmToken]
        userDB.childByAutoId().setValue(dictionary) {
            (error, reference) in
            if error != nil{
                print(error!)
            }else{
                print("token saved successfully!")
                
            }
        }
    }
}

