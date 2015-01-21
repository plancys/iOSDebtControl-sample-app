//
//  AddDebtTableViewController.swift
//  iOSDebtControl
//
//  Created by Kamil on 18/01/15.
//  Copyright (c) 2015 Kamil. All rights reserved.
//

import UIKit
import CoreData

var debt:Debt!

class AddDebtTableViewController: UITableViewController {

    @IBOutlet weak var debtDescText: UITextField!
    
    @IBOutlet weak var debtAmountText: UITextField!
    
    @IBOutlet weak var personConnected: UITextField!
    
    @IBOutlet weak var personPhoneNumber: UITextField!
    
    @IBOutlet weak var isYourLiability: UISwitch!
    
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
        context.save(nil)
        
        //todo: refresh table
        dismissViewControllerAnimated(true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
