//
//  AuthDelegate.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 11/14/22.
//

import Foundation
import Parse

class AuthDelegate:NSObject, PFUserAuthenticationDelegate {
    func restoreAuthentication(withAuthData authData: [String : String]?) -> Bool {
        return true
    }
}
