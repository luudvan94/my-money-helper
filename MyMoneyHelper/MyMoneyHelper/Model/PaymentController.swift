//
//  PaymentController.swift
//  MyMoneyHelper
//
//  Created by Van Luu on 7/3/19.
//  Copyright © 2019 luuvan. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

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
    
    func add(_ payment: Payment) -> Bool {
        do {
            try realm.write {
                self.wallet.payments.append(payment)
            }
            return true
        } catch {
            return false
        }
    }
    
    func remove(_ payment: Payment) -> Bool {
        do {
            try realm.write {
                self.payments.remove(at: self.payments.index(of: payment)!)
            }
            return true
        } catch {
            return false
        }
    }
    
    func setCurrentPayment(_ payment: Payment) {
        self.currentPayment = payment
    }
    
    func updateCurrentPayment(_ handler: (Payment) -> Void) -> Payment? {
        do {
            try realm.write {
                handler(currentPayment)
            }
            
            return currentPayment
        } catch {
            return nil
        }
        
    }
}

extension PaymentController: ReactiveCompatible {}

extension Reactive where Base == PaymentController {
    func add(payment: Payment) -> Observable<Bool> {
        return .create { observer in
            let result = self.base.add(payment)
            observer.onNext(result)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func remove(payment: Payment) -> Observable<Bool> {
        return .create { observer in
            let result = self.base.remove(payment)
            observer.onNext(result)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func updateCurrentPayment(_ handler: @escaping (Payment) -> Void) -> Observable<Payment?> {
        return .create { observer in
            if let payment = self.base.updateCurrentPayment(handler) {
                observer.onNext(payment)
                observer.onCompleted()
            } else {
                observer.onNext(nil)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
