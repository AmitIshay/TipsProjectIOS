//
//  AppDelegate.swift
//  TipMaster
//
//  Created by Student14 on 11/08/2024.
//

import UIKit
import FirebaseCore
import Firebase
import FirebaseDatabase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveDataToFirebase()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveDataToFirebase()
    }

    func saveDataToFirebase() {
        // Get the current user's unique ID
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        let db = Database.database().reference()

        // Access the ListViewController
        if let navigationController = window?.rootViewController as? UINavigationController,
           let listVC = navigationController.viewControllers.first(where: { $0 is ListViewController }) as? ListViewController {
            let workersData: [[String: Any]] = listVC.models.map { worker in
                return [
                    "name": worker.name,
                    "role": worker.role,
                    "hours": worker.hours,
                    "tip": worker.tip ?? 0.0,
                    "id": worker.id
                ]
            }

            // Save data under the specific user's ID
            db.child("users").child(userId).child("workers").setValue(workersData) { error, _ in
                if let error = error {
                    print("Error writing data: \(error)")
                } else {
                    print("Data successfully written!")
                }
            }
        }
    }
   
    



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
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

