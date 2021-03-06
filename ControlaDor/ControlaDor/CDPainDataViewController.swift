//
//  CDPainDataViewController.swift
//  ControlaDor
//
//  Created by Isaías Lima on 09/03/16.
//  Copyright (c) 2016 PainController. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import ResearchKit

protocol CDPainDataViewControllerInput
{
    func dataSource(viewModel: CDPainDataViewModel)
    func reloadTableView()
    func alertControllerPresent(title: String, message: String)
    func activityIndicatorAnimate(trigger: CDActivityViewAnimator)
}

protocol CDPainDataViewControllerOutput
{
    func fetchRequest(request: CDPainDataRequest)
    func createPainDatum(request: CDPainDatumRequest)
    func deletePainDatum(request: CDPainDatumDeleteRequest, completionHandler: (success: Bool) -> Void)
    func decodeImagesFromString(dataString: String) -> [UIImage]?
    func sendPainDataToDoctor(request: CDPainDataServerRequest)
}

class CDPainDataViewController: UITableViewController, CDPainDataViewControllerInput, ORKTaskViewControllerDelegate
{
    var output: CDPainDataViewControllerOutput!
    var router: CDPainDataRouter!
  
    // MARK: Object lifecycle
  
    override func awakeFromNib()
    {
        super.awakeFromNib()
        CDPainDataConfigurator.sharedInstance.configure(self)
    }
  
    // MARK: View lifecycle
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        makeFetchRequest()
    }
  
    // MARK: Event handling
  
    func makeFetchRequest()
    {
        // NOTE: Ask the Interactor to do some work
    
        let request = CDPainDataRequest(entityName: "CDPainDatum")
        output.fetchRequest(request)
    }
  
    // MARK: Display logic
  
    func dataSource(viewModel: CDPainDataViewModel)
    {
        let dates = viewModel.dates
        let locals = viewModel.locals
        let intensities = viewModel.intensities
        painData = [(NSDate,Double,String)]()
        for i in 0..<dates.count {
            painData.append((dates[i],intensities[i],locals[i]))
        }
    }

    // MARK: Actions

    @IBAction func addPainDatum(sender: UIBarButtonItem) {

        let taskViewController = IRLTaskViewController(task: CDPainDatumTask, taskRunUUID: nil)
        taskViewController.delegate = self
        taskViewController.outputDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0], isDirectory: true)
        presentViewController(taskViewController, animated: true, completion: nil)

    }

    @IBAction func sendToServer(sender: AnyObject) {
        let request = CDPainDataServerRequest(painData: painData)
        output.sendPainDataToDoctor(request)
    }

    func alertControllerPresent(title: String, message: String) {
        let actionController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: { (alert) -> Void in
            self.activityIndicatorAnimate(.Stop)
        })
        actionController.addAction(action)
        presentViewController(actionController, animated: true, completion: nil)
    }

    // MARK: TableView instance properties

    let reuseIdentifier = "PainDatum"
    var painData:[(NSDate,Double,String)]!
    let overlayTransitioningDelegate = OverlayTransitioningDelegate()
    var overlay: CDActivityView!

    func activityIndicatorAnimate(trigger: CDActivityViewAnimator) {
        switch trigger {
        case .Start:
            if overlay == nil {
                overlay = CDActivityView(frame: view.frame)
                overlay.configureAppearance()
                overlay.hidden = true
                view.addSubview(overlay)
            }
            overlay.hidden = false
            overlay.animateIndicatorView(.Start)
        case .Stop:
            overlay.hidden = true
            overlay.animateIndicatorView(.Stop)
        }
    }

    // MARK: TableView DataSource and Delegate Methods

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return painData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)

        let painDatum = painData[indexPath.row]

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle

        cell?.textLabel?.text = "\(painDatum.1)"
        cell?.detailTextLabel?.text = dateFormatter.stringFromDate(painDatum.0)

        return cell!
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {

            let alertController = UIAlertController(title: "Quer deletar esse dado?", message: "Seu médico poderá precisar dele", preferredStyle: .ActionSheet)

            let delete = UIAlertAction(title: "Sim", style: .Destructive, handler: { (action) -> Void in
                let painDatum = self.painData[indexPath.row]
                let request = CDPainDatumDeleteRequest(date: painDatum.0, intensity: painDatum.1, local: painDatum.2)
                self.output.deletePainDatum(request, completionHandler: { (success) -> Void in
                    if success {
                        self.reloadTableView()
                    } else {
                        // tratar
                    }
                })
            })

            let cancel = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)

            alertController.addAction(delete)
            alertController.addAction(cancel)

            self.presentViewController(alertController, animated: true, completion: nil)

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let painDatum = painData[indexPath.row]
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OverlayViewController") as! CDPainDatumViewController
        if let images = output.decodeImagesFromString(painDatum.2) {
            controller.images = images
            prepareOverlayVC(controller)
            presentViewController(controller, animated: true, completion: nil)
        } else {
            print(#function,"returned nil")
        }
    }

    // MARK: Transition methods for showing photos

    private func prepareOverlayVC(overlayVC: UIViewController) {
        overlayVC.transitioningDelegate = overlayTransitioningDelegate
        overlayVC.modalPresentationStyle = .Custom
    }

    // MARK: TaskViewControllerDelegate

    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {

        if reason == .Completed {
            let taskResult = taskViewController.result
            let results = taskViewController.dictionaryWithTaskResult(taskResult)
            let images = [(taskViewController as! IRLTaskViewController).shaderFrontImage , (taskViewController as! IRLTaskViewController).shaderBackImage]
            let intensity = Double(results["Intensidade da dor"]!)
            let dataString = NSKeyedArchiver.archivedDataWithRootObject(images).base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            output.createPainDatum(CDPainDatumRequest(intensity: intensity!,local: dataString))
        }

        // Aguardando método de upload para o server

        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    func taskViewController(taskViewController: ORKTaskViewController, viewControllerForStep step: ORKStep) -> ORKStepViewController? {

        var controller = ViewController.instantiateViewControllerFromStoryboard(UIStoryboard(name: "Main", bundle: nil))
        controller?.step = step
        controller?.continueButtonTitle = "Next"

        if step.identifier == "HumanBodyFront" {
            controller?.delegate = taskViewController
            controller?.bodyTypeSet(.Front)
            return controller
        } else if step.identifier == "HumanBodyBack" {
            controller?.delegate = taskViewController
            controller?.bodyTypeSet(.Back)
            return controller
        }

        controller = nil
        return nil
    }

    func reloadTableView() {
        makeFetchRequest()
        tableView.reloadData()
    }

}
