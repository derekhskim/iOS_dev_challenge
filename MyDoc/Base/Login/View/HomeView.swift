//
//  HomeView.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/06.
//

import SwiftUI

struct HomeView: View {
    var myDocumentList: [MyDocument] = MyDocumentList.myDocList
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(.gray.opacity(0.25))
    }
    
    var body: some View {
        
        ZStack{
            
            List(myDocumentList, id: \.id) { MyDocument in
                NavigationLink(destination: DocumentDetailView(document: MyDocument), label: {
                    VStack(alignment: .leading){
                        Text(MyDocument.title)
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                            .fontWeight(.semibold)
                            .padding(.bottom, 3)
                        
                        Text(MyDocument.description)
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                        
                        HStack {
                            Text(MyDocument.uploadDate)
                                .foregroundColor(.secondary)
                            Spacer()
                            if MyDocument.status == false {
                                Text("New")
                                    .foregroundColor(.red)
                            } else {
                                Text("Completed")
                                    .foregroundColor(.green)
                            }
                                
                        }
                        .font(.system(size: 14))
                        .padding(.top, 3)
                    }
                })
                .toolbar{
                    ToolbarItem(placement: .principal) {
                        ZStack{
                            Text("My Docs").font(.title3)
                                .foregroundColor(Color.black.opacity(0.5))
                        }
                    }
                }
            }
            
            GeometryReader{ reader in
                Color.gray.opacity(0.65)
                    .frame(height: 90, alignment: .top)
                    .ignoresSafeArea()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeView()
        }
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
    
}
