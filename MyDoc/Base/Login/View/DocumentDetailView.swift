//
//  DocumentDetailView.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/08.
//

import SwiftUI

struct DocumentDetailView: View {
    
    var document: MyDocument
    
    var body: some View {
        VStack(alignment: .leading){
            Text(document.title)
                .padding(.bottom, 3)
            
            Text(document.description)
            
            HStack {
                Text(document.uploadDate)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 3)
            
            Divider()
            
            Text("Label")
                .font(.title)
                .padding(.bottom, 1)
            Text("Description")
        }
        .padding(.horizontal)
    }
}

struct DocumentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentDetailView(document: MyDocumentList.myDocList.first!)
    }
}
