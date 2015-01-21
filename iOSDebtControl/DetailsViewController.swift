//
//  DetailsViewController.swift
//  iOSDebtControl
//
//  Created by Kamil on 21/01/15.
//  Copyright (c) 2015 Kamil. All rights reserved.
//

import UIKit
import MessageUI
import MapKit

class DetailsViewController: UIViewController, MFMessageComposeViewControllerDelegate, MKMapViewDelegate {

    var debtDesc: String = ""
    
    var debt: Debt?
    
    @IBOutlet weak var descLabel: UILabel!
   
    @IBOutlet weak var amountLable: UILabel!
    
    @IBOutlet weak var connectedPersonLabel: UILabel!
    
    @IBOutlet weak var areYouDebtorLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func requestRepayment(sender: AnyObject) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.recipients = [debt!.personPhoneNumber]
            messageVC.body = "Hey \(debt?.connectedPerson)! Could you repay me debt (\(debt?.description)) for \(debt?.amount) USD?"
            self.presentViewController(messageVC, animated: true, completion: nil)
        }
        else {
            println("User hasn't setup Messages.app")
            let alertController = UIAlertController(title: "Unable to send SMS", message:
                "You don't have SMS application. Remember, you cannot test sms functionality on emulator!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descLabel.text = debt?.desc
        amountLable.text = debt!.amount.stringValue + " USD"
        connectedPersonLabel.text = debt?.connectedPerson
        
        var areYouDebtor = "Yes"
        if debt?.isLiability == false {
            areYouDebtor = "No"
        }
        areYouDebtorLabel.text = areYouDebtor
        
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        let date :NSDate = debt!.creationDate
        dateLabel.text =  dateFormatter.stringFromDate(date)
        
        
        setupMap(debt!.latitude, longitudeVal: debt!.longitude)
    }
    
    func setupMap(latitudeVal:Double, longitudeVal:Double){
        var latitude:CLLocationDegrees = latitudeVal
        var longitude:CLLocationDegrees = longitudeVal
        var latDelta:CLLocationDegrees = 0.01
        var longDelta:CLLocationDegrees = 0.01
        var span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location,span)
        mapView.setRegion(region, animated: false)
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Debt creation place"
        annotation.subtitle = "here your debt was created"
        mapView.addAnnotation(annotation)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        switch (result.value) {
        case MessageComposeResultCancelled.value:
            println("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.value:
            println("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.value:
            println("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }

}
