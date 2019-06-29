//
//  Wallet.swift
//  MyMoneyHelper
//
//  Created by Van Luu on 6/28/19.
//  Copyright © 2019 luuvan. All rights reserved.
//

import Foundation
import RealmSwift

class Wallet: Object {
    @objc dynamic var name = ""
    @objc dynamic var desc = ""
    let payments = List<Payment>()
}

