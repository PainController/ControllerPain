//
//  AppDelegate.swift
//  ControlaDor
//
//  Created by Isaías Lima on 08/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        CDCloudKitStack.createSubscriptionForConsult("") { (success) -> Void in }

        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstOpen = userDefaults.boolForKey("FirstOpen")

        if !firstOpen {
            let tutorialController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Tutorial")
            window?.rootViewController = tutorialController
            userDefaults.setBool(true, forKey: "FirstOpen")
            userDefaults.synchronize()
        }

        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)

        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()

        if let options: [NSObject: AnyObject] = launchOptions {
            let remoteNotification = options[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject: AnyObject]
            if let notification = remoteNotification {
                self.application(application, didReceiveRemoteNotification: notification)
            }
        }

        return true
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        let ckNotification = CKNotification(fromRemoteNotificationDictionary: userInfo as! [String : NSObject])
        if ckNotification.notificationType == .Query {
            let recordID = (ckNotification as! CKQueryNotification).recordID
            CDCloudKitStack.fetchConsultRecord(recordID!, completionHandler: { (success, consult) -> Void in
                if !success {
                    // tratar
                } else {
                    let consultData = NSEntityDescription.insertNewObjectForEntityForName("CDConsultData", inManagedObjectContext: CDCoreDataStack.sharedInstance.managedObjectContext) as! CDConsultData
                    let contact: [String : AnyObject] = ["Convenio" : consult!.0.convenio, "Date": consult!.0.date, "Email" : consult!.0.email, "Telephone" : consult!.0.telephone, "Name" : consult!.0.name!]
                    consultData.contact = NSKeyedArchiver.archivedDataWithRootObject(contact)
                    consultData.images = consult!.1
                    consultData.results = consult!.2

                    do {
                        try CDCoreDataStack.sharedInstance.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                }
            })
        }
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CDCoreDataStack.sharedInstance.saveContext()
    }

}

