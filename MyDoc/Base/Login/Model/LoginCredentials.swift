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

struct LoginCredentialsEncodable: Encodable {
    var email: String
    var password: String
}

struct LoginResponse: Decodable {
    let error: DecodableError
    let data: Data
    
    struct Data: Decodable {
        let access_token: String
        let refresh_token: String
    }
}

struct DecodableError: Decodable {
    let code: Int
    let message: String
}


extension LoginCredentials {
    
    static var new: LoginCredentials {
        LoginCredentials(email: "", password: "")
    }
}
