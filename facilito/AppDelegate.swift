//
//  AppDelegate.swift
//  facilito
//
//  Created by iMac Mario on 4/10/22.
//

import UIKit
import GoogleMaps
import ArcGIS

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Configura la clave de licencia ArcGIS
        do {
            try AGSArcGISRuntimeEnvironment.setLicenseKey("runtimelite,1000,rud3302802654,none,FA0RJAY3FP25Y7ZPM148")
        } catch {
            print("Error al configurar la licencia: \(error)")
        }

        // Configura la clave del mapa de Google
        GMSServices.provideAPIKey("AIzaSyAW62lFMPaya0zxvjfDNkXSu16e5HTGoRo")

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

