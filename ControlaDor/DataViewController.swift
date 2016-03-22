//
//  DataViewController.swift
//  Page
//
//  Created by Isaías Lima on 20/10/15.
//  Copyright © 2015 Lima. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet var button: UIButton!
    var dataObject: String = ""
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: dataObject)
        if dataObject == "fourth" {
            imageView.hidden = true
            imageView.image = UIImage()
            button.enabled = true
        } else {
            imageView.hidden = false
            button.enabled = false
        }
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 26.5
        print("?")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        print("Bye")
    }
  
}

