//
//  LoginCredential.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/06.
//

import Foundation

struct LoginCredentials {
    var email: String
    var password: String
}

extension LoginCredentials {
    
    static var new: LoginCredentials {
        LoginCredentials(email: "", password: "")
    }
}
