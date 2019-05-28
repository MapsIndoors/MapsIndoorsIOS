//
//  AppDelegate.swift
//  SimpleMapSwift
//
//  Created by Daniel Nielsen on 25/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

import UIKit
import GoogleMaps
import MapsIndoors


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let mApiKey = "57e4e4992e74800ef8b69718" //MapsIndoors Test API Key
    static let gApiKey = "AIzaSyBzX2eRNamzCfKcFbPbnqJ6JjpBMHOfVMA"
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        GMSServices.provideAPIKey(AppDelegate.gApiKey)
        MapsIndoors.provideAPIKey(AppDelegate.mApiKey, googleAPIKey: AppDelegate.gApiKey)

        return true
    }
}
