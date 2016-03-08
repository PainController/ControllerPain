//
//  IRLTaskViewController.swift
//  Research Test
//
//  Created by Isaías Lima on 08/03/16.
//  Copyright © 2016 Lima. All rights reserved.
//

import UIKit
import ResearchKit

class IRLTaskViewController: ORKTaskViewController {

    var shaderFrontImage: UIImage!
    var shaderBackImage: UIImage!

    // MARK: - ORKStepViewControllerDelegate

    override func stepViewController(stepViewController: ORKStepViewController, didFinishWithNavigationDirection direction: ORKStepViewControllerNavigationDirection) {
        super.stepViewController(stepViewController, didFinishWithNavigationDirection: direction)
        if stepViewController.step?.identifier == "HumanBodyFront" {
            let viewController = stepViewController as? ViewController
            shaderFrontImage = viewController?.share()
        } else if stepViewController.step?.identifier == "HumanBodyBack" {
            let viewController = stepViewController as? ViewController
            shaderBackImage = viewController?.share()
        }
    }
    
}
