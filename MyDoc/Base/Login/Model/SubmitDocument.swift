//
//  SubmitDocument.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/10.
//

import Foundation

struct SubmitDocumentEncodable: Encodable {
    var id: String
    var name: String
    var description: String
    var completed: Bool
    var created_at: Date
    var completed_at: Date
}

struct DocumentResponse: Decodable {
    let error: DecodableError
    let data: Data
    
    struct Data: Decodable {
        let access_token: String
        let refresh_token: String
    }
}
