//
//  CDDoctorPresenter.swift
//  ControlaDor
//
//  Created by Isaías Lima on 15/03/16.
//  Copyright (c) 2016 PainController. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol CDDoctorPresenterInput
{
  func presentEntities(response: CDDoctorResponse)
  func reloadTableView()
}

protocol CDDoctorPresenterOutput: class
{
  func displaySomething(viewModel: CDDoctorViewModel)
  func reloadTableView()
}

class CDDoctorPresenter: CDDoctorPresenterInput
{
  weak var output: CDDoctorPresenterOutput!
  
  // MARK: Presentation logic
  
  func presentEntities(response: CDDoctorResponse)
  {
    // NOTE: Format the response from the Interactor and pass the result back to the View Controller

    let entities = response.entities
    var contacts = [CDUserContact]()
    var images = [[UIImage]]()
    var results = [String]()

    for entity in entities {
        let contactData = entity.contact
        let contactHash = NSKeyedUnarchiver.unarchiveObjectWithData(contactData!) as! [String : AnyObject]
        let contact = CDUserContact(name: contactHash["Name"] as? String, convenio: contactHash["Convenio"] as! String, telephone: contactHash["Telephone"] as! String, email: contactHash["Email"] as! String, date: contactHash["Date"] as! NSDate)
        contacts.append(contact)

        let imagesData = entity.images
        let image = NSKeyedUnarchiver.unarchiveObjectWithData(imagesData!) as! [UIImage]
        images.append(image)

        let result = entity.results
        results.append(result!)
    }
    
    let viewModel = CDDoctorViewModel(contacts: contacts, images: images, results:  results)
    output.displaySomething(viewModel)
  }

  func reloadTableView()
  {
      output.reloadTableView()
  }
}
