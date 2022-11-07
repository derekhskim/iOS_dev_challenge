//
//  HomeView.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/06.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            VStack(alignment: .leading, spacing: 16) {
                Text("You are Signed In!")
            }
            
            ButtonView(title: "Logout") {
                sessionService.logout()
            }
        }
        .padding(.horizontal, 16)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .principal) {
                    Color.gray
                    .ignoresSafeArea()
                        .overlay(
                    VStack{
                        Text("My Docs").font(.title3)
                            .foregroundColor(Color.black.opacity(0.5))
                            .frame(maxWidth: .infinity, maxHeight: 50)
                })
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeView()
                .environmentObject(SessionServiceImpl())
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
