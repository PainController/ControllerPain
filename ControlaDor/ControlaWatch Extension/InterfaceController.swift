//
//  InterfaceController.swift
//  ControlaWatch Extension
//
//  Created by Isaías Lima on 22/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    private var session: WCSession?
    private var message: [String : AnyObject]?

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
