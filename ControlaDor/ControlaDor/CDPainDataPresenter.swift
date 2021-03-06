//
//  CDPainDataPresenter.swift
//  ControlaDor
//
//  Created by Isaías Lima on 09/03/16.
//  Copyright (c) 2016 PainController. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol CDPainDataPresenterInput
{
  func presentEntities(response: CDPainDataResponse)
  func reloadTableView()
  func alertControllerPresent(title: String, message: String)
  func activityIndicatorAnimate(trigger: CDActivityViewAnimator)
}

protocol CDPainDataPresenterOutput: class
{
  func dataSource(viewModel: CDPainDataViewModel)
  func reloadTableView()
  func alertControllerPresent(title: String, message: String)
  func activityIndicatorAnimate(trigger: CDActivityViewAnimator)
}

class CDPainDataPresenter: CDPainDataPresenterInput
{
  weak var output: CDPainDataPresenterOutput!
  
  // MARK: Presentation logic
  
  func presentEntities(response: CDPainDataResponse)
  {
    var dates = [NSDate]()
    var intensities = [Double]()
    var locals = [String]()

    for datum in response.painEntity {
        dates.append(datum.date!)
        intensities.append(datum.intensity)
        locals.append(datum.local!)
    }
    let viewModel = CDPainDataViewModel(dates: dates, intensities: intensities, locals: locals)
    output.dataSource(viewModel)
  }

  func reloadTableView()
  {
    output.reloadTableView()
  }

  func alertControllerPresent(title: String, message: String)
  {
    output.alertControllerPresent(title, message: message)
  }

  func activityIndicatorAnimate(trigger: CDActivityViewAnimator)
  {
    output.activityIndicatorAnimate(trigger)
  }
}
