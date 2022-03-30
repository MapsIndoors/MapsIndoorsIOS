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
import AppAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let mApiKey = ProcessInfo.processInfo.environment["apiKey"] ?? "57e4e4992e74800ef8b69718" // MapsIndoors Test API Key
    static let gApiKey = ProcessInfo.processInfo.environment["googleApiKey"] ?? "ADD_YOUR_OWN_GOOGLE_MAPS_IOS_API_KEY"
    
    var window: UIWindow?
   
    var currentAuthorizationFlow: OIDExternalUserAgentSession?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey(AppDelegate.gApiKey)
        MapsIndoors.provideAPIKey(AppDelegate.mApiKey, googleAPIKey: AppDelegate.gApiKey)
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
      // Sends the URL to the current authorization flow (if any) which will
      // process it if it relates to an authorization response.
      if let authorizationFlow = self.currentAuthorizationFlow,
                                 authorizationFlow.resumeExternalUserAgentFlow(with: url) {
        self.currentAuthorizationFlow = nil
        return true
      }

      // Your additional URL handling (if any)

      return false
    }
}
