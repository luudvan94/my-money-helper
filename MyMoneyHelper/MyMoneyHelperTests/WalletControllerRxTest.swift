//
//  WalletControllerRxTest.swift
//  MyMoneyHelperTests
//
//  Created by Van Luu on 7/7/19.
//  Copyright © 2019 luuvan. All rights reserved.
//
// swiftlint:disable force_try
import Foundation
import Quick
import Nimble
import RxBlocking
import RealmSwift
@testable import MyMoneyHelper

class WalletControllerRxTest: QuickSpec {
    override func spec() {
        describe("Wallet Controller") {
            var testRealm: Realm!
            var sut: WalletController!
            var wallet: Wallet!
            var anotherWallet: Wallet!
            
            beforeEach {
                testRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "wallet-controller-spec"))
                sut = WalletController(realm: testRealm)
                
                wallet = Wallet()
                wallet.name = "cash"
                wallet.desc = "cash payment"
                
                anotherWallet = Wallet()
                anotherWallet.name = "check"
                anotherWallet.desc = "check payment"
            }
            
            afterEach {
                try! testRealm.write {
                    testRealm.deleteAll()
                }
            }
            
            context("wallet controller with rx") {
                it("add 1 wallet") {
                    expect(try! sut.rx.add(wallet: wallet).toBlocking().first()).to(equal(true))
                }
                
                it("remove wallet") {
                    expect(try! sut.rx.add(wallet: wallet).toBlocking().first()).to(equal(true))
                    expect(try! sut.rx.add(wallet: anotherWallet).toBlocking().first()).to(equal(true))
                    expect(try! sut.rx.remove(wallet: anotherWallet).toBlocking().first()).to(equal(true))
                }
                
                it("update wallet") {
                    expect(try! sut.rx.add(wallet: wallet).toBlocking().first()).to(equal(true))
                    let result = try! sut.rx.update { wallet in
                        wallet.name = "updated wallet"
                    }.toBlocking().first()

                    expect(result).toNot(beNil())
                    expect(result!!.name).to(equal("updated wallet"))
                }
                
                it("select wallet") {
                    expect(try! sut.rx.add(wallet: wallet).toBlocking().first()).to(equal(true))
                    expect(try! sut.rx.add(wallet: anotherWallet).toBlocking().first()).to(equal(true))
                    
                    let selectedWallet = try! sut.rx.setCurrentWallet(wallet).toBlocking().first()
                    
                    expect(selectedWallet).toNot(beNil())
                    expect(selectedWallet!!.name).to(equal(wallet.name))
                }
            }
        }
    }
}
