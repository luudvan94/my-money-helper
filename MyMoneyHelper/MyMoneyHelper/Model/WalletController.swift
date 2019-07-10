//
//  WalletController.swift
//  MyMoneyHelper
//
//  Created by Van Luu on 7/3/19.
//  Copyright © 2019 luuvan. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

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
    
    func add(wallet: Wallet) -> Bool {
        do {
            try realm.write {
                self.realm.add(wallet)
            }
            self.currentWallet = wallet
            
            return true
        } catch {
            return false
        }
    }
    
    func remove(wallet: Wallet) -> Bool {
        do {
            try realm.write {
                self.realm.delete(wallet)
            }
            self.currentWallet = latestUpdateWallet
            
            return true
        } catch {
            return false
        }
        
    }
    
    func update(_ handler: (Wallet) -> Void) -> Wallet? {
        guard let wallet = self.currentWallet else {
            return nil
        }
        
        do {
            try realm.write {
                wallet.lastestUpdate = Date()
                handler(wallet)
            }
            return wallet
        } catch {
            return nil
        }
    }
    
    func setCurrentWallet(_ wallet: Wallet) -> Wallet? {
        do {
            try realm.write {
                wallet.lastestUpdate = Date()
            }
            self.currentWallet = wallet
            
            return wallet
        } catch {
            return nil
        }
        
    }
    
}

extension WalletController: ReactiveCompatible {}

extension Reactive where Base == WalletController {
    func setCurrentWallet(_ wallet: Wallet) -> Observable<Wallet?> {
        return .create { observer in
            if let wallet = self.base.setCurrentWallet(wallet) {
                observer.onNext(wallet)
                observer.onCompleted()
            } else {
                observer.onNext(nil)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func update(_ handler: @escaping (Wallet) -> Void) -> Observable<Wallet?> {
        return .create { observer in
            if let wallet = self.base.update(handler) {
                observer.onNext(wallet)
                observer.onCompleted()
            } else {
                observer.onNext(nil)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func remove(wallet: Wallet) -> Observable<Bool> {
        return .create { observer in
            let result = self.base.remove(wallet: wallet)
            observer.onNext(result)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func add(wallet: Wallet) -> Observable<Bool> {
        return .create { observer in
            let result = self.base.add(wallet: wallet)
            observer.onNext(result)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
