//
//  CDCloudKitStack.swift
//  ControlaDor
//
//  Created by Isaías Lima on 10/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//

import UIKit
import CloudKit

class CDCloudKitStack {

    class func createNewRecordWithObject(object: CDPainDatum, andKey key: String) {
        
    }

    class func createBPIRecord(results: String, images: NSData, contact: CDUserContact, indicator: UIActivityIndicatorView, completionHandler: (success: Bool) -> Void){
        let recordID = CKRecordID(recordName: "CDBPI - consulta : \(NSDate())")
        let record = CKRecord(recordType: "CDBPI", recordID: recordID)

        record["Results"] = results
        record["Images"] = images
        record["Username"] = contact.name
        record["Convenium"] = contact.convenio
        record["Telephone"] = contact.telephone
        record["Email"] = contact.email
        record["Date"] = contact.date

        dispatch_async(dispatch_get_main_queue()) { () -> Void in

            indicator.hidden = false
            indicator.startAnimating()

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let container: CKContainer? = CKContainer.defaultContainer() {
                    let database = container!.publicCloudDatabase
                    database.saveRecord(record) { (record, error) -> Void in
                        if error != nil {
                            indicator.stopAnimating()
                            indicator.hidden = true
                            completionHandler(success: false)
                        } else {
                            indicator.hidden = true
                            indicator.stopAnimating()
                            completionHandler(success: true)
                        }
                    }
                } else {
                    completionHandler(success: true)
                }
            })
        }

    }

}
