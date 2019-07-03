//
//  PaymentControllerInMemorySpec.swift
//  MyMoneyHelperTests
//
//  Created by Van Luu on 7/3/19.
//  Copyright © 2019 luuvan. All rights reserved.
//
// swiftlint:disable force_try
import Foundation
import Quick
import Nimble
import RealmSwift
@testable import MyMoneyHelper

class PaymentControllerInMemorySpec: QuickSpec {
    override func spec() {
        var testRealm: Realm!
        var wallet: Wallet!
        var walletController: WalletController!
        var sut: PaymentController!
        var payment: Payment!
        var anotherPayment: Payment!
        
        beforeEach {
            testRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "payment-controller-spec"))
            walletController = WalletController(realm: testRealm)
            
            wallet = Wallet()
            wallet.name = "cash"
            wallet.desc = "cash payment"
            
            try! walletController.add(wallet: wallet)
            sut = PaymentController(wallet: wallet, realm: testRealm)
            
            payment = Payment()
            payment.name = "payment A"
            payment.value = 10.0
            payment.detail = "detail of payment A"
            
            anotherPayment = Payment()
            anotherPayment.name = "payment B"
            anotherPayment.value = 15.0
            anotherPayment.detail = "detail of payment B"
        }
        
        afterEach {
            try! testRealm.write {
                testRealm.deleteAll()
            }
        }
        
        context("payment") {
            it("add new payment") {
                expect(sut.payments.count).to(equal(0))
                
                try! sut.add(payment)
                
                expect(sut.payments.count).to(equal(1))
            }
            
            it("add 2 new payments") {
                expect(sut.payments.count).to(equal(0))
                
                try! sut.add(payment)
                try! sut.add(anotherPayment)
                
                expect(sut.payments.count).to(equal(2))
            }
            
            it("remove payment") {
                try! sut.add(payment)
                try! sut.add(anotherPayment)
                
                expect(sut.payments.count).to(equal(2))
                
                try! sut.remove(anotherPayment)
                
                expect(sut.payments.count).to(equal(1))
            }
            
            it("update payment") {
                try! sut.add(payment)
                
                expect(sut.payments.count).to(equal(1))
                
                sut.setCurrentPayment(payment)
                try! sut.updateCurrentPayment { payment in
                    payment.name = "payment of update"
                    payment.value = 21.0
                }
                
                expect(payment.name).to(equal("payment of update"))
                expect(payment.value).to(equal(21.0))
            }
        }
        
    }
}
