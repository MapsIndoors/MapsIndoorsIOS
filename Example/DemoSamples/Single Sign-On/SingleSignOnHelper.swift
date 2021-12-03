//
//  SingleSignOnHelper.swift
//  Demos
//
//  Created by Daniel Nielsen on 26/10/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

import Foundation
import AppAuth
import MapsIndoors

class SingleSignOnHelper {
    var authState: OIDAuthState?
    
    func openLoginFlow ( for controller:UIViewController, completion: @escaping () -> Void ) {
        MapsIndoors.fetchAuthenticationDetails { details, error in
            
            guard let authDetails = details else { return }
            
            guard let client = authDetails.authClients.first else { return }
            
            let issuer = URL(string: authDetails.authIssuer)!
            
            let redirectUrl = URL(string: "mapsindoorsdemo://auth")!
            
            OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { configuration, error in
                
                guard let config = configuration else {
                    return
                }
                
                var additionalParams:[String:String]? = nil
                if let idp = client.preferredIDPS.first {
                    additionalParams = ["acr_values":"idp:\(idp)"]
                }
                
                let request = OIDAuthorizationRequest(configuration: config,
                                                      clientId: client.clientID,
                                                      scopes: [OIDScopeOpenID, OIDScopeProfile, authDetails.authScope],
                                                      redirectURL: redirectUrl,
                                                      responseType: OIDResponseTypeCode,
                                                      additionalParameters: additionalParams)
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                appDelegate.currentAuthorizationFlow =
                OIDAuthState.authState(byPresenting: request, presenting: controller) { [self] authState, error in
                    if let authState = authState {
                        self.authState = authState
                        print("Got authorization tokens. Access token: " +
                              "\(authState.lastTokenResponse?.accessToken ?? "nil")")
                    } else {
                        print("Authorization error: \(error?.localizedDescription ?? "Unknown error")")
                        self.authState = nil
                    }
                    completion()
                }
            }
        }
    }
}
