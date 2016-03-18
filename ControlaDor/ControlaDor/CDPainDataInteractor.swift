//
//  CDPainDataInteractor.swift
//  ControlaDor
//
//  Created by Isaías Lima on 09/03/16.
//  Copyright (c) 2016 PainController. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol CDPainDataInteractorInput
{
  func fetchRequest(request: CDPainDataRequest)
  func createPainDatum(request: CDPainDatumRequest)
  func deletePainDatum(request: CDPainDatumDeleteRequest, completionHandler: (success: Bool) -> Void)
  func decodeImagesFromString(dataString: String) -> [UIImage]?
  func sendPainDataToDoctor(request: CDPainDataServerRequest)
}

protocol CDPainDataInteractorOutput
{
  func presentEntities(response: CDPainDataResponse)
  func reloadTableView()
  func activityIndicatorAnimate(trigger: CDActivityViewAnimator)
  func alertControllerPresent(title: String, message: String)
}

class CDPainDataInteractor: NSObject, CDPainDataInteractorInput
{
  var output: CDPainDataInteractorOutput!
  var worker: CDPersistentStoreWorker!
  var persistentWorker: CDPainDataWorker!
  var lastUpdateEntities: [CDPainDatum]!

    override init() {
        super.init()
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "animate", name: "Alert", object: nil)
    }
  
  // MARK: Business logic
  
  func fetchRequest(request: CDPainDataRequest)
  {
    // NOTE: Create some Worker to do the work
    
    worker = CDPersistentStoreWorker(entityName: request.entityName)

    do {
        try worker.makeFetchRequest({ (entities) -> Void in
            self.lastUpdateEntities = entities as! [CDPainDatum]
            let response = CDPainDataResponse(painEntity: entities as! [CDPainDatum])
            self.output.presentEntities(response)
        })
    } catch {
        print(error)
    }
  }

  func sendPainDataToDoctor(request: CDPainDataServerRequest)
  {
    output.activityIndicatorAnimate(.Start)

    CDCloudKitStack.createRecords(request)
    CDCloudKitStack.uploadRecords { (success) -> Void in
        if !success {
            self.output.alertControllerPresent("Erro de conexão", message: "Verifique se você está conectado à internet")
        }
    }
  }

  func animate()
  {
    output.alertControllerPresent("Dados de dor enviados", message: "Pode retirá-los de seu celular")
  }

  func createPainDatum(request: CDPainDatumRequest)
  {
    persistentWorker = CDPainDataWorker(request: request)
    persistentWorker.createPainDatum { (success) -> Void in
        if success {
            self.output.reloadTableView()
        } else {
            // tratar
        }
    }
  }

  func deletePainDatum(request: CDPainDatumDeleteRequest, completionHandler: (success: Bool) -> Void) {

    persistentWorker = CDPainDataWorker(request: request)

    for entity in lastUpdateEntities {
        if entity.date == request.date {
            persistentWorker.deletePainDatum(entity, completionHandler: { (success) -> Void in
                if success {
                    completionHandler(success: true)
                    self.output.reloadTableView()
                } else {
                    completionHandler(success: false)
                    // tratar
                }
            })
        }
    }
  }

  func decodeImagesFromString(dataString: String) -> [UIImage]? {
    let data = NSData(base64EncodedString: dataString, options: .IgnoreUnknownCharacters)
    let images = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? [UIImage]
    return images
  }
}
