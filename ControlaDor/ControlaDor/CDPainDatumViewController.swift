//
//  CDPainDatumViewController.swift
//  ControlaDor
//
//  Created by Isaías Lima on 10/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//

import UIKit

class CDPainDatumViewController: UIViewController {

    var images = [UIImage]()
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.translatesAutoresizingMaskIntoConstraints = true
        var imageView1 = UIImageView(frame: scrollView.frame)
        imageView1.image = images.first
        imageView1.contentMode = .ScaleAspectFit
        var imageView2 = UIImageView(frame: scrollView.frame)
        imageView2.image = images.last
        imageView2.contentMode = .ScaleAspectFit
        var x = imageView2.frame.origin.x
        x = x + imageView2.frame.origin.x
        imageView2.frame.origin.x = x

        scrollView.addSubview(imageView1)
        scrollView.addSubview(imageView2)

        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
