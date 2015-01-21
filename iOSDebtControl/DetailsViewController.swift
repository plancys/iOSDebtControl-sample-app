//
//  DetailsViewController.swift
//  iOSDebtControl
//
//  Created by Kamil on 21/01/15.
//  Copyright (c) 2015 Kamil. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var debtDesc: String = ""
    
    var debt: Debt?
    
    @IBOutlet weak var descLabel: UILabel!
   
    @IBOutlet weak var amountLable: UILabel!
    
    @IBOutlet weak var connectedPersonLabel: UILabel!
    
    @IBOutlet weak var areYouDebtorLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func requestRepayment(sender: AnyObject) {
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
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let date :NSDate = debt!.creationDate
        dateLabel.text =  dateFormatter.stringFromDate(date)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
