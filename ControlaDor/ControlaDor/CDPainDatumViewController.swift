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

        let frame = CGRectMake(0, 15, view.frame.size.width - 100, scrollView.frame.size.height)
        scrollView.frame.size = frame.size

        scrollView.translatesAutoresizingMaskIntoConstraints = true
        let imageView1 = UIImageView(frame: frame)
        imageView1.image = images.first
        imageView1.contentMode = .ScaleAspectFit
        let imageView2 = UIImageView(frame: frame)
        imageView2.image = images.last
        imageView2.contentMode = .ScaleAspectFit
        var x = imageView2.frame.origin.x
        x += frame.size.width
        imageView2.frame.origin.x = x

        scrollView.addSubview(imageView1)
        scrollView.addSubview(imageView2)

        scrollView.contentSize = CGSizeMake(frame.size.width * 2, scrollView.frame.size.height)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
