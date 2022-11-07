//
//  ButtonComponentView.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/06.
//

import SwiftUI

struct ButtonView: View {
    
    typealias ActionHandler = () -> Void
    
    let title: String
    let background: Color
    let foreground: Color
    let border: Color
    let handler: ActionHandler
    
    private let cornerRadius: CGFloat = 0
    
    internal init(title: String,
                  background: Color = Color.gray.opacity(0.4),
                  foreground: Color = Color.black.opacity(0.4),
                  border: Color = Color.gray.opacity(0.7),
                  handler: @escaping ButtonView.ActionHandler) {
        self.title = title
        self.background = background
        self.foreground = foreground
        self.border = border
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler, label: {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: 50)
        })
        .background(background)
        .foregroundColor(foreground)
        .font(.system(size: 16, weight: .bold))
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(border, lineWidth: 2)
        )
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(title: "Login") { }
            .preview(with: "Primary Button View")
    }
}
