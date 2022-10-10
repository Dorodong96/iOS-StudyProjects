//
//  AppDelegate.swift
//  CreditCardList
//
//  Created by DongKyu Kim on 2022/10/05.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        
        db.collection("creditCardList").getDocuments { snapshot, _ in
            guard snapshot?.isEmpty == true else { return }

            
            let card0Ref = db.collection("creditCardList").document("card0")
            let card1Ref = db.collection("creditCardList").document("card1")
            let card2Ref = db.collection("creditCardList").document("card2")
            let card3Ref = db.collection("creditCardList").document("card3")
            let card4Ref = db.collection("creditCardList").document("card4")
            let card5Ref = db.collection("creditCardList").document("card5")
            let card6Ref = db.collection("creditCardList").document("card6")
            let card7Ref = db.collection("creditCardList").document("card7")
            let card8Ref = db.collection("creditCardList").document("card8")
            let card9Ref = db.collection("creditCardList").document("card9")
            
            do {
                try card0Ref.setData(from: CreditCardDummy.card0)
                try card1Ref.setData(from: CreditCardDummy.card1)
                try card2Ref.setData(from: CreditCardDummy.card2)
                try card3Ref.setData(from: CreditCardDummy.card3)
                try card4Ref.setData(from: CreditCardDummy.card4)
                try card5Ref.setData(from: CreditCardDummy.card5)
                try card6Ref.setData(from: CreditCardDummy.card6)
                try card7Ref.setData(from: CreditCardDummy.card7)
                try card8Ref.setData(from: CreditCardDummy.card8)
                try card9Ref.setData(from: CreditCardDummy.card9)
            } catch let error {
                print("ERROR writing card to Firestore \(error.localizedDescription)")
            }
            

        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

