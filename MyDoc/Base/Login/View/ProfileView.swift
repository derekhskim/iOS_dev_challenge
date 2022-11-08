//
//  ProfileView.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/07.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        ZStack{
            VStack {
                Text("Your Profile Page")
                ButtonView(title: "Logout") {
                    sessionService.logout()
                }
            }
            .padding(.horizontal, 16)
            
            GeometryReader{ reader in
                Color.gray.opacity(0.65)
                    .frame(height: 100, alignment: .top)
                    .ignoresSafeArea()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionServiceImpl())
    }
}
