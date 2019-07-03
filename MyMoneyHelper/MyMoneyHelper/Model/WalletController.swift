//
//  WalletController.swift
//  MyMoneyHelper
//
//  Created by Van Luu on 7/3/19.
//  Copyright © 2019 luuvan. All rights reserved.
//

import Foundation
import RealmSwift

class WalletController {
    let realm: Realm!
    private var currentWallet: Wallet?
    
    private var latestUpdateWallet: Wallet? {
        return realm.objects(Wallet.self).sorted(byKeyPath: "lastestUpdate", ascending: false).first
    }
    
    var activeWallet: Wallet? {
        return currentWallet
    }
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    convenience init() throws {
        self.init(realm: try Realm())
    }
    
    func add(wallet: Wallet) throws {
        try realm.write {
            self.realm.add(wallet)
        }
        self.currentWallet = wallet
    }
    
    func remove(wallet: Wallet) throws {
        try realm.write {
            self.realm.delete(wallet)
        }
        self.currentWallet = latestUpdateWallet
    }
    
    func update(_ handler: (Wallet) -> Void) throws {
        guard let wallet = self.currentWallet else {
            return
        }
        
        try realm.write {
            wallet.lastestUpdate = Date()
            handler(wallet)
        }
        
    }
    
    func setCurrentWallet(_ wallet: Wallet) throws {
        try realm.write {
            wallet.lastestUpdate = Date()
        }
        self.currentWallet = wallet
    }
    
}
