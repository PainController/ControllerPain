//
//  CDCloudKitWatchStack.swift
//  ControlaDor
//
//  Created by Isaías Lima on 22/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//

import WatchKit
import WatchConnectivity

class CDWatchConnectivityStack: NSObject, WCSessionDelegate {

    private var session: WCSession?
    private var message: [String : AnyObject]?

    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session!.delegate = self
            session!.activateSession()
            message = [String : AnyObject]()
        } else {
        }
    }

    func addInfoToSend(info: (String , AnyObject)) {
        message![info.0] = info.1
    }

    func sendMessage(errorHandler: ((NSError) -> Void)?) {
        session?.sendMessage(message!, replyHandler: nil, errorHandler: errorHandler)
    }

}
