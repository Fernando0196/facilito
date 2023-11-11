//
//  AppDelegate.swift
//  facilito
//
//  Created by iMac Mario on 4/10/22.
//

import UIKit
import GoogleMaps
import ArcGIS
import GoogleSignIn
import Firebase
import FBSDKCoreKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Configura la clave de licencia ArcGIS
        do {
            try AGSArcGISRuntimeEnvironment.setLicenseKey("runtimelite,1000,rud3302802654,none,FA0RJAY3FP25Y7ZPM148")
        } catch {
            print("Error al configurar la licencia: \(error)")
        }

        // Configura la clave del mapa de Google
        GMSServices.provideAPIKey("AIzaSyAW62lFMPaya0zxvjfDNkXSu16e5HTGoRo")
        
        //gmail
        //396165979336-it03dgf5h7l2ic6h3guf2asd0ps8utus.apps.googleusercontent.com
        
        // Configura la clave de Facebook SDK
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        
        

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }


}

