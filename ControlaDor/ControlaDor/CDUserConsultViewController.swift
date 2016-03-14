//
//  CDUserConsultViewController.swift
//  ControlaDor
//
//  Created by Isaías Lima on 11/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//

import UIKit

class CDUserConsultViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var conveniumField: UITextField!
    @IBOutlet weak var telephoneField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var results: String!
    var imagesData: NSData!

    override func viewDidLoad() {
        super.viewDidLoad()

        // taking userDefaults for placeholders : agilizar processo de agendamento

        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userData = userDefaults.objectForKey("Contact") as? [String : String]

        nameField.text = userData!["Nome"]
        conveniumField.text = userData!["Convênio"]
        telephoneField.text = userData!["Telefone"]
        mailField.text = userData!["E-mail"]

        // textFields delegation

        nameField.delegate = self
        conveniumField.delegate = self
        telephoneField.delegate = self
        mailField.delegate = self

        // datePicker config

        datePicker.minimumDate = NSDate()

        // indicator

        activityIndicator.hidden = true

    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func createUserContact() -> CDUserContact {
        var contact = CDUserContact()
        contact.name = nameField.text
        contact.convenio = conveniumField.text
        contact.telephone = telephoneField.text
        contact.email = mailField.text
        contact.date = datePicker.date
        return contact
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            let contact = createUserContact()
            CDCloudKitStack.createBPIRecord(results, images: imagesData, contact: contact, indicator: activityIndicator, completionHandler: { (success) -> Void in
                if success {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                } else {
                    let actionController = UIAlertController(title: "Erro de conexão", message: "Preencha os dados corretamente ou tente novamente mais tarde", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "Ok", style: .Default, handler: { (alert) -> Void in
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    })
                    actionController.addAction(action)
                    self.presentViewController(actionController, animated: true, completion: nil)
                }
            })
        } else if indexPath.section == 1 && indexPath.row == 1 {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}
