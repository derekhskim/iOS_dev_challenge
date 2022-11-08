//
//  MyDocList.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/08.
//

import SwiftUI

struct MyDocument {
    let title: String
    let description: String
    let uploadDate: String
//    let status: String
}

struct MyDocumentList {
    
    static let myDocList = [
    MyDocument(title: "JSA 1", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed neque ac nibh.", uploadDate: "Created At: ")
    ]
}
