//
//  CDWatchConnectivityStack.swift
//  ControlaDor
//
//  Created by Isaías Lima on 22/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//

import UIKit
import WatchConnectivity

@available(iOS 9.0, *)
class CDWatchConnectivityStack: NSObject, WCSessionDelegate {

    private var session: WCSession?
    private var message: [String : AnyObject]?

    func configureSession() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session!.delegate = self
            session!.activateSession()
            message = [String : AnyObject]()
        } else {
        }
    }

    @objc func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        guard let msg = message["PainDate"] as? String else {
            print(#function,"Nil variable")
            return
        }

        dispatch_async(dispatch_get_main_queue()) { 
            print(#function, msg)
        }
    }
    
}
