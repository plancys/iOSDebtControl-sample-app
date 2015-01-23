//
//  AddDebtTableViewController.swift
//  iOSDebtControl
//
//  Created by Kamil on 18/01/15.
//  Copyright (c) 2015 Kamil. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class AddDebtTableViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var newDebt:Debt?
    
    @IBOutlet weak var debtDescText: UITextField!
    
    @IBOutlet weak var debtAmountText: UITextField!
    
    @IBOutlet weak var personConnected: UITextField!
    
    @IBOutlet weak var personPhoneNumber: UITextField!
    
    @IBOutlet weak var isYourLiability: UISwitch!
    
    var manager = CLLocationManager()
    
    var location:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("Init Adding debt view")
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "save" {
            var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            var context: NSManagedObjectContext = appDel.managedObjectContext!
            newDebt = NSEntityDescription.insertNewObjectForEntityForName("Debt", inManagedObjectContext: context) as? Debt
            newDebt?.setValue(debtDescText.text, forKey: "desc")
            var string = NSString(string: debtAmountText.text)
            newDebt?.setValue(string.doubleValue, forKey: "amount")
            newDebt?.setValue(personPhoneNumber.text, forKey: "personPhoneNumber")
            newDebt?.setValue(personConnected.text, forKey: "connectedPerson")
            newDebt?.setValue(isYourLiability.on == true, forKey: "isLiability")
            newDebt?.setValue(NSDate(), forKey: "creationDate")
            
            if(location != nil ){

                newDebt?.setValue(location!.coordinate.longitude, forKey: "longitude")
                newDebt?.setValue(location!.coordinate.latitude, forKey: "latitude")
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]) {
        println("locations = \(locations)")
        location = locations[0] as? CLLocation
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError) {
        println(error)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
}
