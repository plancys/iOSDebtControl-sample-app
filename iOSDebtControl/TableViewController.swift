//
//  TableViewController.swift
//  iOSDebtControl
//
//  Created by Kamil on 18/01/15.
//  Copyright (c) 2015 Kamil. All rights reserved.
//

import UIKit
import CoreData




class TableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    var debts = [Debt]()
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
        }()

    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    
    @IBAction func done(segue:UIStoryboardSegue) {
        var newDebtVC = segue.sourceViewController as AddDebtTableViewController
        saveNewItem(newDebtVC.newDebt!)
    }

    func save() {
        var error : NSError?
        if(managedObjectContext!.save(&error) ) {
            println(error?.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("Reloading table view...")
        fetchDebts()
    }

    func fetchDebts() {
        NSLog("fetching debts...")
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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            let debtToDelete = debts[indexPath.row]
            managedObjectContext?.deleteObject(debtToDelete)
            self.fetchDebts()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            save()
        }
    }
    
    func saveNewItem(debtItem : Debt) {
        self.fetchDebts()
        if let newItemIndex = find(debts, debtItem) {
            let newLogItemIndexPath = NSIndexPath(forRow: newItemIndex, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([ newLogItemIndexPath ], withRowAnimation: .Automatic)
            save()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToDetails" {
            var secondViewController : DetailsViewController = segue.destinationViewController as DetailsViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let selectedDebt = debts[indexPath!.row] as Debt
            secondViewController.debt = selectedDebt
        } else {
            println("Segue->")
        }
    }
}
