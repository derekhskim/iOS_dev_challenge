//
//  DocumentDetailView.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/08.
//

import SwiftUI
import Combine

struct DocumentDetailView: View {
    
    var document: MyDocument
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading){
                    Text(document.title)
                        .padding(.bottom, 3)
                        .font(.title)
                    
                    Text(document.description)
                    
                    HStack {
                        if document.status == true { Text(document.uploadDate)} else { Text("NA")
                        }
                    }
                    .foregroundColor(.secondary)
                    .padding(.top, 3)
                    
                    Divider()
                    
                    TitleAndDescription(title: "Label", description: "Description")
                    
                    DocumentForm(title: "Text Field (*)", description: "Description", height: 40)
                        .padding(.bottom, 15)
                    DocumentForm(title: "Text Field (*)", description: "Description", height: 120)
                        .padding(.bottom, 15)
                    
                    VStack(alignment: .leading){
                        TitleAndDescription(title: "Options", description: "Description")
                        
                        RadioButtonGroups{ selected in
                            print("Selected Option Id: \(selected)")
                        }
                    }
                    
                    VStack(alignment: .leading){ // Multiple Selection
                        TitleAndDescription(title: "Multiple Selection", description: "Description")
                        MultipleSelections(name: "Option 1", isCompleted: false)
                            .padding(.bottom, 1)
                        MultipleSelections(name: "Option 2", isCompleted: false)
                            .padding(.bottom, 1)
                        MultipleSelections(name: "Option 3", isCompleted: false)
                            .padding(.bottom, 1)
                        MultipleSelections(name: "Option 4", isCompleted: false)
                            .padding(.bottom, 1)
// MARK:- Could not use list in a scrollview, as it messes up the UI even if I use GeomtryReader
                    }
                    .padding(.vertical)

                    
                    ButtonView(title: "Complete") {
                        }
                    .frame(height: 50)
                }
                .padding(.horizontal)
            }
            
    }
}

struct MultipleSelections: View {
    
    let id = UUID()
    let name: String
    @State var isCompleted: Bool = false
    
    var body: some View {
            HStack{
                Image(systemName: isCompleted ? "checkmark.square" : "square")
                    .onTapGesture {
                        isCompleted.toggle()
                    }
                Text(name)
            }
    }
}

struct DocumentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentDetailView(document: MyDocumentList.myDocList.first!)
    }
}

struct DocumentForm: View {
    
    @State private var textField: String = ""
    
    var title: String
    var description: String
    var height: CGFloat
    
    let textLimit = 1024
    
    var body: some View {
        
        VStack (alignment: .leading){
            Text(title)
                .font(.title)
                .padding(.bottom, 1)
            Text(description)
            
            TextField(
                "Place holder", text: $textField
            )
            .onReceive(Just(textField)) {_ in limitText(textLimit) }
            .padding(10)
            .disableAutocorrection(true)
            .frame(height: height, alignment: .top)
            .border(.secondary)
        }
    }
    
    func limitText(_ upper: Int) {
        if textField.count > upper {
            textField = String(textField.prefix(upper))
        }
    }
}

struct TitleAndDescription: View {
    var title: String
    var description: String
    
    var body: some View{
        VStack (alignment: .leading){
            Text(title)
                .font(.title)
                .padding(.bottom, 0.5)
            Text(description)
                .padding(.bottom, 15)
        }
    }
}

enum Options: String {
    case one = "Option 1"
    case two = "Option 2"
    case three = "Option 3"
}

struct RadioButtonGroups: View {
    let callback: (String) -> ()
    
    @State var selectedId: String = ""
    
    var body: some View {
        VStack {
            radioOption1
            radioOption2
            radioOption3
        }
    }
    
    var radioOption1: some View {
        RadioButtonField(
            id: Options.one.rawValue,
            label: Options.one.rawValue,
            isSelected: selectedId == Options.one.rawValue ? true : false,
            callback: radioGroupCallback)
    }
    
    var radioOption2: some View {
        RadioButtonField(
            id: Options.two.rawValue,
            label: Options.two.rawValue,
            isSelected: selectedId == Options.two.rawValue ? true : false,
            callback: radioGroupCallback)
    }
    
    var radioOption3: some View {
        RadioButtonField(
            id: Options.three.rawValue,
            label: Options.three.rawValue,
            isSelected: selectedId == Options.three.rawValue ? true : false,
            callback: radioGroupCallback)
    }
    
    func radioGroupCallback (id: String){
        selectedId = id
        callback(id)
    }
}

struct RadioButtonField: View {
    let id: String
    let label: String
    let size: CGFloat
    let textSize: CGFloat
    let isSelected: Bool
    let callback: (String) -> ()
    
    init(
        id: String,
        label: String,
        size: CGFloat = 20,
        textSize: CGFloat = 14,
        isSelected: Bool = false,
        callback: @escaping (String) -> ()
    ) {
        self.id = id
        self.label = label
        self.size = size
        self.textSize = textSize
        self.isSelected = isSelected
        self.callback = callback
    }
    
    var body: some View {
        Button(action: {
            self.callback(self.id)
        }) {
            HStack(alignment: .center, spacing: 10){
                Image(systemName: self.isSelected ? "largecircle.fill.circle" : "circle")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                
                Text(label)
                    .font(Font.system(size: textSize))
                
                Spacer()
            }
        }.foregroundColor(Color.black)
    }
}
