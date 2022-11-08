//
//  ChatView.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/07.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        ZStack{
            Text("This Page shows Chats")
            
            GeometryReader{ reader in
                Color.gray.opacity(0.65)
                    .frame(height: 100, alignment: .top)
                    .ignoresSafeArea()
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
