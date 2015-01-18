//
//  Debt.swift
//  iOSDebtControl
//
//  Created by Kamil on 18/01/15.
//  Copyright (c) 2015 Kamil. All rights reserved.
//

import UIKit

class Debt : NSObject {
    
    var desc: String
    var amount: Int
    
    init(desc: String, amount: Int){
        self.desc = desc
        self.amount = amount
        super.init()
    }
}
