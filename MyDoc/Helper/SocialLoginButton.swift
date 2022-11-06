//
//  SocialLoginButton.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/06.
//

import SwiftUI

struct SocialLoginButton: View {
    var image: Image
    var text: Text
    
    var body: some View {
        HStack{
            image
                .resizable()
                .frame(width: 30.0, height: 30.0)
                .padding(.horizontal)
            Spacer()
            text
                .font(.title2)
                .foregroundColor(.black)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(50.0)
        .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
    }
}
