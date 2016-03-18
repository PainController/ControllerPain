//
//  CDActivityView.swift
//  ControlaDor
//
//  Created by Isaías Lima on 17/03/16.
//  Copyright © 2016 PainController. All rights reserved.
//

import UIKit

enum CDActivityViewAnimator {
    case Start
    case Stop
}

class CDActivityView: UIView {

    private var indicatorView: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        addIndicatorView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func addIndicatorView() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        let rect = CGRectMake(frame.size.width/2 - 30, frame.size.height/2.2 - 30, 60, 60)
        activityIndicator.frame = rect
        indicatorView = activityIndicator
        addSubview(indicatorView)
    }

    func configureAppearance() {
        backgroundColor = UIColor.lightGrayColor()
        alpha = 0.7
    }

    func animateIndicatorView(trigger: CDActivityViewAnimator) {
        switch trigger {
        case .Start:
            indicatorView.startAnimating()
            return
        case .Stop:
            indicatorView.stopAnimating()
            return
        }
    }

}
