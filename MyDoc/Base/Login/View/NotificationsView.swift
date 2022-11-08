//
//  NotificationsView.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/07.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        ZStack{
            Text("You have 10 notifications\n\nPlease Check the messages.")
        
            GeometryReader{ reader in
                Color.gray.opacity(0.65)
                    .frame(height: 100, alignment: .top)
                    .ignoresSafeArea()
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
