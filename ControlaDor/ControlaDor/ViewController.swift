//
//  ViewController.swift
//  DrawPad
//
//  Created by Jean-Pierre Distler on 13.11.14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import UIKit
import ResearchKit

enum HumanBodyTipe {
    case Front
    case Back
}

class ViewController: ORKStepViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var bodyImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var eraseButton: UIButton!
    var bodyImage = UIImage(named: "HumanBodyFront")

    // MARK: - Coloring properties
    var lastPoint = CGPointZero
    var red: CGFloat = 255.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 20.0
    var opacity: CGFloat = 0.3
    var swiped = false

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 3
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1).CGColor

        eraseButton.layer.cornerRadius = 3
        eraseButton.layer.borderWidth = 1
        eraseButton.layer.borderColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1).CGColor
        bodyImageView.image = bodyImage
    }

    func bodyTypeSet(type: HumanBodyTipe) {
        switch type {
        case .Front:
            bodyImage = UIImage(named: "HumanBodyFront")
        case .Back:
            bodyImage = UIImage(named: "HumanBodyBack")
        }
    }

    // MARK: - Storyboard init

    class func instantiateViewControllerFromStoryboard(storyboard: UIStoryboard) -> ViewController? {
        return storyboard.instantiateViewControllerWithIdentifier("HumanBodyPain") as? ViewController
    }

    // MARK: - Drawing methods

    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        // 3
        CGContextSetLineCap(context, .Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, .Normal)
        // 4
        CGContextStrokePath(context)
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        view.bringSubviewToFront(tempImageView)
        UIGraphicsEndImageContext()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.locationInView(view)
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .Normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tempImageView.image = nil
    }

    // MARK: - Actions

    @IBAction func reset(sender: AnyObject) {
        mainImageView.image = nil
    }

    @IBAction func nextStep(sender: AnyObject) {
        goForward()
    }

    func share() -> UIImage {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        bodyImageView.image?.drawInRect(CGRect(x: (mainImageView.frame.size.width - bodyImageView.frame.size.width)/2, y: (mainImageView.frame.size.height - bodyImageView.frame.size.height)/2 - 31, width: bodyImageView.frame.size.width, height: bodyImageView.frame.size.height))
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0,
            width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}

