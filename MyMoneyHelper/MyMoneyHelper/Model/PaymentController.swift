//
//  PaymentController.swift
//  MyMoneyHelper
//
//  Created by Van Luu on 7/3/19.
//  Copyright © 2019 luuvan. All rights reserved.
//

import Foundation
import RealmSwift

class PaymentController {
    let realm: Realm!
    private var wallet: Wallet!
    var payments: List<Payment> {
        return wallet.payments
    }
    private var currentPayment: Payment!
    
    init(wallet: Wallet, realm: Realm) {
        self.realm = realm
        self.wallet = wallet
    }
    
    convenience init(wallet: Wallet) throws {
        self.init(wallet: wallet, realm: try Realm())
    }
    
    func add(_ payment: Payment) throws {
        try realm.write {
            self.wallet.payments.append(payment)
        }
    }
    
    func remove(_ payment: Payment) throws {
        try realm.write {
            self.payments.remove(at: self.payments.index(of: payment)!)
        }
    }
    
    func setCurrentPayment(_ payment: Payment) {
        self.currentPayment = payment
    }
    
    func updateCurrentPayment(_ handler: (Payment) -> Void) throws {
        try realm.write {
            handler(currentPayment)
        }
    }
}
