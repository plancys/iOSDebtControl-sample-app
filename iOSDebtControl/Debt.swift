//
//  Debt.swift
//  iOSDebtControl
//
//  Created by Kamil on 20/01/15.
//  Copyright (c) 2015 Kamil. All rights reserved.
//

import Foundation
import CoreData

@objc(Debt)
class Debt: NSManagedObject {

    @NSManaged var amount: NSNumber
    @NSManaged var desc: String
    @NSManaged var connectedPerson: String
    @NSManaged var isLiability: NSNumber
    @NSManaged var personPhoneNumber: String
    @NSManaged var creationDate: NSDate
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double

}
