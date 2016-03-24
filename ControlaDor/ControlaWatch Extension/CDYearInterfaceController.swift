//
//  CDYearInterfaceController.swift
//  ControlaDor
//
//  Created by Isaías Lima on 22/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class CDYearInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var yearInterfacePicker: WKInterfacePicker!
    @IBOutlet var monthInterfacePicker: WKInterfacePicker!
    @IBOutlet var dayInterfacePicker: WKInterfacePicker!

    var currentDay = 1
    var currentMonth = 1
    var currentYear = 2016

    var years: [Int]!
    var monthsOfYear: [Int]!
    var daysOfMonth: [Int]!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        years = [Int]()
        for i in 2016...2020 {
            years.append(i)
        }

        monthsOfYear = [Int]()
        for i in 01...12 {
            monthsOfYear.append(i)
        }

        daysOfMonth = [Int]()
        for i in 01...31 {
            daysOfMonth.append(i)
        }
        
        let yearPickerItems: [WKPickerItem] = years.map {
            let pickerItem = WKPickerItem()
            pickerItem.title = "\($0)"
            return pickerItem
        }

        let monthPickerItems: [WKPickerItem] = monthsOfYear.map {
            let pickerItem = WKPickerItem()
            pickerItem.title = "\($0)"
            return pickerItem
        }

        let dayPickerItems: [WKPickerItem] = daysOfMonth.map {
            let pickerItem = WKPickerItem()
            pickerItem.title = "\($0)"
            return pickerItem
        }
        
        yearInterfacePicker.setItems(yearPickerItems)
        monthInterfacePicker.setItems(monthPickerItems)
        dayInterfacePicker.setItems(dayPickerItems)
    }

    // MARK: Agendamento

    @IBAction func setConsult() {
        let date = "\(currentDay)/" + "\(currentMonth)/" + "\(currentYear)"
        print(#function,date)

        configureSession()
        addInfoToSend(("ConsultDate" , date))
        sendMessage { (error) in
            let yep = WKAlertAction(title: "Ok", style: .Default) { () -> Void in
                print(#function,"Sim")
            }
            WKInterfaceDevice.currentDevice().playHaptic(.Failure)
            self.presentAlertControllerWithTitle("Erro", message: "Não há conexão com o iPhone", preferredStyle: .ActionSheet, actions: [yep])
        }
    }

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

    func addInfoToSend(info: (String , AnyObject)) {
        message![info.0] = info.1
    }

    func sendMessage(errorHandler: ((NSError) -> Void)?) {
        session?.sendMessage(message!, replyHandler: nil, errorHandler: errorHandler)
    }

    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        guard let msg = message["ErrorAlert"] as? String else {
            print(#function, "Not an alert message")
            if let success = message["SuccessAlert"] as? String {
                let yep = WKAlertAction(title: "Ok", style: .Default) { () -> Void in
                    print(#function,"Sim")
                }
                WKInterfaceDevice.currentDevice().playHaptic(.Success)
                presentAlertControllerWithTitle("Consulta solicitada", message: success, preferredStyle: .ActionSheet, actions: [yep])
                return
            }
            return
        }

        let yep = WKAlertAction(title: "Ok", style: .Default) { () -> Void in
            print(#function,"Sim")
        }
        WKInterfaceDevice.currentDevice().playHaptic(.Failure)
        presentAlertControllerWithTitle("Erro de conexão", message: msg, preferredStyle: .ActionSheet, actions: [yep])
    }

    // MARK: Reconhecimento de dados do picker

    @IBAction func setDay(value: Int) {
        currentDay = daysOfMonth![value]
    }

    @IBAction func setMonth(value: Int) {
        currentMonth = monthsOfYear![value]
    }

    @IBAction func setYear(value: Int) {
        currentYear = years![value]
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
