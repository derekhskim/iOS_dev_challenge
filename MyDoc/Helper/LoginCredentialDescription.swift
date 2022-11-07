//
//  LoginCredentialDescription.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/06.
//

import SwiftUI

struct loginCredentialDescription: View{
    var text: Text
    
    var body: some View {
        HStack{
            text
                .foregroundColor(Color.black.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }
}
