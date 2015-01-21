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

var debt:Debt!

class AddDebtTableViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var debtDescText: UITextField!
    
    @IBOutlet weak var debtAmountText: UITextField!
    
    @IBOutlet weak var personConnected: UITextField!
    
    @IBOutlet weak var personPhoneNumber: UITextField!
    
    @IBOutlet weak var isYourLiability: UISwitch!
    
    var manager = CLLocationManager()
    
    var location:CLLocation?
    
    @IBAction func cancelDebtAdding(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

    }
    @IBAction func addDebtAction(sender: AnyObject) {
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        var newDebt = NSEntityDescription.insertNewObjectForEntityForName("Debt", inManagedObjectContext: context) as Debt
        
        newDebt.desc = debtDescText.text
        var string = NSString(string: debtAmountText.text)
        newDebt.amount = string.doubleValue
        newDebt.personPhoneNumber = personPhoneNumber.text
        newDebt.connectedPerson = personConnected.text
        newDebt.isLiability = isYourLiability.on == true
        newDebt.creationDate = NSDate()
        newDebt.longitude = location!.coordinate.longitude
        newDebt.latitude = location!.coordinate.latitude
        
        
        //todo: refresh table
        context.save(nil)
        dismissViewControllerAnimated(true, completion: nil)
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        println("Init Adding debt view")
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()


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
