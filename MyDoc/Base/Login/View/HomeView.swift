//
//  HomeView.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/06.
//

import SwiftUI

struct HomeView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor(.gray.opacity(0.25))
    }
    
    var body: some View {
        
        ZStack{
            
            VStack(alignment: .leading, spacing: 16) {
                Text("You are Signed In!")
            }
            .ignoresSafeArea()
            .toolbar{
                ToolbarItem(placement: .principal) {
                        ZStack{
                            Text("My Docs").font(.title3)
                                .foregroundColor(Color.black.opacity(0.5))
                    }
                }
            }
            
            GeometryReader{ reader in
                Color.gray.opacity(0.65)
                    .frame(height: 100, alignment: .top)
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
