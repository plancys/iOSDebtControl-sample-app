//
//  SettingsViewController.swift
//  iOSDebtControl
//
//  Created by Kamil on 22/01/15.
//  Copyright (c) 2015 Kamil. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController  ,UIPickerViewDataSource,UIPickerViewDelegate {

    var currencies = [["EUR", "USD", "PLN"],["EUR", "USD", "PLN"]]
    
    @IBOutlet weak var sourcePicker: UIPickerView!
    
    
    var source:String?
    var dest:String?
    
    @IBAction func saveSettings(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setValue(source, forKey:"sourceCurrency")
        NSUserDefaults.standardUserDefaults().setValue(dest, forKey:"destinationCurrency")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourcePicker.delegate = self
        sourcePicker.dataSource = self;


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUsersChoice(){
        source = currencies[0][sourcePicker.selectedRowInComponent(0)]
        dest = currencies[1][sourcePicker.selectedRowInComponent(1)]

    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies[component].count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateUsersChoice()
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return currencies[component][row]
    }


}
