//
//  CDUserRouter.swift
//  ControlaDor
//
//  Created by Isaías Lima on 08/03/16.
//  Copyright (c) 2016 PainController. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol CDUserRouterInput
{
  func navigateToSomewhere()
}

class CDUserRouter: CDUserRouterInput
{
  weak var viewController: CDUserViewController!
  
  // MARK: Navigation
  
  func navigateToSomewhere()
  {
    // NOTE: Teach the router how to navigate to another scene. Some examples follow:

    viewController.performSegueWithIdentifier("Consulta", sender: nil)

  }
  
  // MARK: Communication
  
  func passDataToNextScene(segue: UIStoryboardSegue)
  {
    // NOTE: Teach the router which scenes it can communicate with
    
    if segue.identifier == "Consulta" {
      passDataToSomewhereScene(segue)
    }
  }
  
  func passDataToSomewhereScene(segue: UIStoryboardSegue)
  {
    // NOTE: Teach the router how to pass data to the next scene
    
    let userConsultViewcontroller = segue.destinationViewController as! CDUserConsultViewController
    userConsultViewcontroller.results = viewController.userConsult.briefPainInventoryData
    userConsultViewcontroller.imagesData = viewController.userConsult.imagesData

  }
}
