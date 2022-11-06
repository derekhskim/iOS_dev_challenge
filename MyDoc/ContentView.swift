//
//  ContentView.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/05.
//

import SwiftUI
import Firebase
import GoogleSignIn
//import GoogleSignInSwift

struct ContentView: View {
//    @AppStorage("log_status") var logStatus: Bool = false
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var signInWithAppleObject = SignInWithAppleObject()
        
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                Text("MyDoc")
                    .font(.largeTitle.bold())
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .padding(.bottom, 50)
                
                // Google Login Button
                Button(action: {
                    handleLogin()
                }, label: {
                    SocialLoginButton(image: Image(uiImage: UIImage(named: "google_logo")!), text: Text("Continue with Google"))
                })
                
                // Apple Login Button
                Button(action: {signInWithAppleObject.signInWithApple()}, label: {
                    SocialLoginButton(image: Image(uiImage: UIImage(named: "apple_logo")!), text: Text("Continue with Apple"))
                        .padding(.vertical)

                })
                
                loginCredentialDescription(text: Text("Email"))
                    .padding(.top)
                
                TextField("Enter email", text: $email)
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .border(Color.gray.opacity(0.7))
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                
                loginCredentialDescription(text: Text("Password"))
                    .padding(.top)
                
                SecureField("Enter password", text: $password)
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .border(Color.gray.opacity(0.7))
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                    .padding(.bottom, 50)
                
                Button("Login") {
                    
                }
                .foregroundColor(Color.black.opacity(0.4))
                .frame(maxWidth: .infinity, maxHeight: 50)
                .border(Color.gray.opacity(0.7))
                .background(Color.gray.opacity(0.4))
                
            }
            .padding()
        }
    }
    
    func handleLogin(){
        
        // Google Sign In
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) {
            [self] user, err in
            
            if let error = err {
                print(error.localizedDescription)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            // Firebase Authentication
            Auth.auth().signIn(with: credential) { result, err in
                
                if let error = err {
                    print(error.localizedDescription)
                    return
                }
                
                // Displaying Username
                guard let user = result?.user else{
                    return
                }
                
                print(user.displayName ?? "Success!")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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

struct loginCredentialDescription: View{
    var text: Text
    
    var body: some View {
        HStack{
            text
                .foregroundColor(Color.black.opacity(0.4))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }
}

extension View{
    func getRect () -> CGRect{
        return UIScreen.main.bounds
    }
    
    // Retreiving RootView Controller
    func getRootViewController() -> UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        
        return root
    }
}
