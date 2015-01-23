//
//  TableViewController.swift
//  iOSDebtControl
//
//  Created by Kamil on 18/01/15.
//  Copyright (c) 2015 Kamil. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate,  UISearchBarDelegate, UISearchDisplayDelegate {

    var debts = [Debt]()
    var filteredDebts = [Debt]()
    let scopes = ["All", "Liability", "Lent"]
    
    
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
        self.searchDisplayController!.searchBar.scopeButtonTitles = scopes
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
    
    
    
//    func filterContentForSearchText(searchText: String) {
//        // Filter the array using the filter method
//        self.filteredDebts = self.debts.filter({( debt: Debt) -> Bool in
////            let categoryMatch = (scope == "All") || (candy.category == scope)
////            let stringMatch = candy.name.rangeOfString(searchText)
//            var description:NSString = NSString(string: debt.desc)
//            return description.containsString(searchText)
//        })
//    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
            self.filteredDebts = self.debts.filter({( debt : Debt) -> Bool in
                var categoryMatch = (scope == "All")
                    || (scope == "Liability" && debt.isLiability == 1)
                    || (scope == "Lent" && debt.isLiability == 0)
                
                var stringMatch = debt.connectedPerson.rangeOfString(searchText)
                return categoryMatch && (stringMatch != nil)
            })
        
    }

    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
//        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        self.searchDisplayController!.searchBar.scopeButtonTitles = scopes
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!,
        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
            let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
            self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
            return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredDebts.count
        } else {
            return self.debts.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("Loading data to table...")
        let cell = self.tableView.dequeueReusableCellWithIdentifier("DebtCell", forIndexPath: indexPath) as UITableViewCell
        var debtToRow:Debt?
        if tableView == self.searchDisplayController!.searchResultsTableView {
            debtToRow = filteredDebts[indexPath.row]
        } else {
            debtToRow = debts[indexPath.row]
        }
        //let debt = debts[ indexPath.row ] as Debt
        cell.textLabel?.text = "\(debtToRow!.desc) [with \(debtToRow!.connectedPerson)]"
        cell.detailTextLabel?.text = debtToRow!.amount.stringValue + NSLocalizedString("currency_code", comment: "...")
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
