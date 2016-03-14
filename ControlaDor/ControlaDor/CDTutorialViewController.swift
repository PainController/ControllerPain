//
//  CDTutorialViewController.swift
//  ControlaDor
//
//  Created by Isaías Lima on 14/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//

import UIKit

class CDTutorialViewController: UITableViewController, UITextFieldDelegate {

    // TextFields
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var conveniumField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var mailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.delegate = self
        conveniumField.delegate = self
        phoneField.delegate = self
        mailField.delegate = self
    }

    // MARK: TextField delegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func createUserDefaults(data: [String : String]) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(data, forKey: "Contact")
        userDefaults.synchronize()
    }

    func textFieldDataArray() -> [String : String] {
        return ["Nome" : nameField.text!, "Convênio" : conveniumField.text!, "Telefone" : phoneField.text!, "E-mail" : mailField.text!]
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            let data = textFieldDataArray()
            createUserDefaults(data)
            performSegueWithIdentifier("Tutorial", sender: self)
        }
    }

}
