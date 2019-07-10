//
//  WalletControllerInMemorySpec.swift
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

class WalletControllerInMemorySpec: QuickSpec {
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
            
            context("Wallet") {
                it("add wallet to the Realm") {
                    expect(testRealm.objects(Wallet.self).count).to(equal(0))
                    
                    let wallet = Wallet()
                    wallet.name = "cash"
                    wallet.desc = "cash payment"
                    _ = sut.add(wallet: wallet)
                    
                    expect(testRealm.objects(Wallet.self).count).to(equal(1))
                    
                }
                
                it("add 2 wallets to the Realm") {
                    expect(testRealm.objects(Wallet.self).count).to(equal(0))
                    
                    _ = sut.add(wallet: wallet)
                    _ = sut.add(wallet: anotherWallet)
                    
                    expect(testRealm.objects(Wallet.self).count).to(equal(2))
                }
                
                it("load lastest wallet") {
                   
                    _ = sut.add(wallet: wallet)
                    _ = sut.add(wallet: anotherWallet)
                    
                    expect(sut.activeWallet).notTo(beNil())
                    expect(sut.activeWallet!.name).to(equal("check"))
                }
                
                it("remove wallet") {
                    
                    _ = sut.add(wallet: wallet)
                    _ = sut.add(wallet: anotherWallet)
                    
                    _ = sut.remove(wallet: anotherWallet)
                    
                    expect(testRealm.objects(Wallet.self).count).to(equal(1))
                }
                
                it("load correct active wallet after remove current active wallet") {
                    
                    _ = sut.add(wallet: wallet)
                    _ = sut.add(wallet: anotherWallet)
                    
                    _ = sut.remove(wallet: anotherWallet)
                    
                    expect(sut.activeWallet).notTo(beNil())
                    expect(sut.activeWallet!.name).to(equal("cash"))
                }
                
                it("update active wallet name and detail") {

                    _ = sut.add(wallet: wallet)
                    _ = sut.add(wallet: anotherWallet)

                    _ = sut.update { wallet in
                        wallet.name = "cash of me"
                        wallet.desc = "cash of myself"
                    }
                    
                    expect(sut.activeWallet!.name).to(equal("cash of me"))
                    expect(sut.activeWallet!.desc).to(equal("cash of myself"))
                }
                
                it("choose and display correct active wallet") {
                    _ = sut.add(wallet: wallet)
                    _ = sut.add(wallet: anotherWallet)
                    
                    _ = sut.setCurrentWallet(wallet)
                    
                    expect(sut.activeWallet).notTo(beNil())
                    expect(sut.activeWallet!.name).to(equal("cash"))
                }
            }
        }
    }
}
