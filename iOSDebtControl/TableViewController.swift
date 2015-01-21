//
//  TableViewController.swift
//  iOSDebtControl
//
//  Created by Kamil on 18/01/15.
//  Copyright (c) 2015 Kamil. All rights reserved.
//

import UIKit
import CoreData


var debts = [Debt]()

class TableViewController: UITableViewController {

    var indexOfSelectedPerson = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDebts()
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext!
//
//        var newDebt = NSEntityDescription.insertNewObjectForEntityForName("Debt", inManagedObjectContext: context) as NSManagedObject
//        
//        newDebt.setValue("Opis", forKey: "desc")
//        newDebt.setValue(23.43, forKey: "amount")
//        newDebt.setValue("Osoba", forKey: "connectedPerson")
//        newDebt.setValue("423432423", forKey: "personPhoneNumber")
//        newDebt.setValue(true, forKey: "isLiability")
//        newDebt.setValue(NSDate(), forKey: "creationDate")
//        
//        context.save(nil)
        
        var request = NSFetchRequest(entityName: "Debt")
        request.returnsObjectsAsFaults = false
        var results = context.executeFetchRequest(request, error: nil)
        
        if results?.count > 0 {
            for result: AnyObject in results! {
                println(result.description)
            }
        }
        else {
            println("No data")
        }

    }
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
        }()
    
    func fetchDebts() {
        NSLog("fetching debts...")
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Debt")
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResult = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Debt] {
            debts = fetchResult
        }
        NSLog("Fetched.")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("Loading data to table...")
        let cell = tableView.dequeueReusableCellWithIdentifier("DebtCell", forIndexPath: indexPath) as UITableViewCell
        let debt = debts[ indexPath.row ] as Debt
        cell.textLabel?.text = debt.desc
        cell.detailTextLabel?.text = debt.amount.stringValue + " USD"
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let debtToDelete = debts[indexPath.row]
            managedObjectContext?.delete(debtToDelete)
            self.fetchDebts()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToDetails" {
            var secondViewController : DetailsViewController = segue.destinationViewController as DetailsViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let selectedDebt = debts[indexPath!.row] as Debt
            secondViewController.debt = selectedDebt
        } else {
            
        }
    }
}
