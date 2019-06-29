//
//  Payment.swift
//  MyMoneyHelper
//
//  Created by Van Luu on 6/28/19.
//  Copyright © 2019 luuvan. All rights reserved.
//

import Foundation
import RealmSwift

class Payment: Object {
    @objc dynamic var value: Double = 0.0
    @objc dynamic var detail = ""
    @objc dynamic var time = Date()
    @objc dynamic var place = ""
    @objc dynamic var category: Category?
}
