//
//  MyDocList.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/08.
//

import SwiftUI

struct MyDocument {
    let id = UUID()
    let title: String
    let description: String
    let uploadDate: String
    let status: Bool
}

struct MyDocumentList {
    
    static let myDocList = [
        MyDocument(title: "JSA 1", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed neque ac nibh.", uploadDate: "Created At: \(Date().displayFormat)", status: false),
        MyDocument(title: "JSA 2", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed neque ac nibh.", uploadDate: "Created At: \(Date().displayFormat)", status: true),
        MyDocument(title: "JSA 3", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed neque ac nibh.", uploadDate: "Created At: \(Date().displayFormat)", status: false),
        MyDocument(title: "JSA 4", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed neque ac nibh.", uploadDate: "Created At: \(Date().displayFormat)", status: false),
        MyDocument(title: "JSA 5", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed neque ac nibh.", uploadDate: "Created At: \(Date().displayFormat)", status: false),
        MyDocument(title: "JSA 6", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed neque ac nibh.", uploadDate: "Created At: \(Date().displayFormat)", status: false)
    ]
}

extension Date {
    var displayFormat: String {
        self.formatted(
            .dateTime
                .year()
                .month(.wide)
                .day()
        )
    }
}
