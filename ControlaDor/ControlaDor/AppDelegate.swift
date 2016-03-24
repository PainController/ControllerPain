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
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        if #available(iOS 9.0, *) {
            if WCSession.isSupported() {
                WCSession.defaultSession().delegate = self
                WCSession.defaultSession().activateSession()
            }
        } else {
            // Fallback on earlier versions
        }

        print(NSUserDefaults.standardUserDefaults().objectForKey("Contact"))

        UINavigationBar.appearance().barTintColor = .whiteColor()

        UITabBar.appearance().barTintColor = .whiteColor()

        CDCloudKitStack.createSubscriptionForConsult("") { (success) -> Void in }

        return true
    }

    @available(iOS 9.0, *)
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        guard let msg = message["ConsultDate"] as? String else {
            print(#function,"Nil variable")
            return
        }

        dispatch_async(dispatch_get_main_queue()) {
            let defaults = NSUserDefaults.standardUserDefaults()
            if let data = defaults.objectForKey("BFIUpdated") {
                let doctorData = data as! NSData
                let dataPack = NSKeyedUnarchiver.unarchiveObjectWithData(doctorData) as! NSArray
                let results = dataPack.firstObject as! [String : String]
                let images = dataPack.lastObject as! [UIImage]
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                do {
                    let jsonData = try NSJSONSerialization.dataWithJSONObject(results, options: .PrettyPrinted)
                    let jsonText = NSString(data: jsonData, encoding: NSASCIIStringEncoding)
                    let imagesData = NSKeyedArchiver.archivedDataWithRootObject(images)
                    guard let contact = self.createUserContact(dateFormatter.dateFromString(msg)!) else {
                        session.sendMessage(["ErrorAlert" : "Não existem dados de contato cadastrados no iPhone"], replyHandler: nil, errorHandler: nil)
                        return
                    }

                    CDCloudKitStack.createBPIRecord(String(jsonText!), images: imagesData, contact: contact, indicator: UIActivityIndicatorView(), completionHandler: { (success) in
                        if !success {
                            session.sendMessage(["ErrorAlert" : "Não pôde se conectar com o iCloud\nReconecte o iPhone à internet"], replyHandler: nil, errorHandler: nil)
                        } else {
                            session.sendMessage(["SuccessAlert" : "com sucesso"], replyHandler: nil, errorHandler: nil)
                        }
                    })
                } catch {
                    print(error)
                }
            } else {
                session.sendMessage(["ErrorAlert" : "Você não fez o Inventário Breve de Dor no iPhone"], replyHandler: nil, errorHandler: nil)
            }
        }
    }

    private func createUserContact(date: NSDate) -> CDUserContact? {
        var contact = CDUserContact()

        let userDefaults = NSUserDefaults.standardUserDefaults()
        guard let userData = userDefaults.objectForKey("Contact") as? [String : String] else {
            return nil
        }

        let name = userData["Nome"]
        let convenium = userData["Convênio"]
        let phone = userData["Telefone"]
        let mail = userData["E-mail"]

        contact.name = name
        contact.convenio = convenium
        contact.telephone = phone
        contact.email = mail
        contact.date = date
        return contact

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

