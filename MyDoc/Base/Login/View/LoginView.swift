//
//  ContentView.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/05.
//

import SwiftUI
import Firebase
import GoogleSignIn

class AppViewModel: ObservableObject {
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            // Signed In
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
//    func signUp(email: String, password: String) {
//        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
//            guard result != nil, error == nil else {
//                return
//            }
//
//            // Signed Up
//            self?.signedIn = true
//        }
//    }
}

struct SignInView: View {
    
    @StateObject private var vm = LoginViewModelImpl(
        service: LoginServiceImpl()
    )
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @State private var signInWithAppleObject = SignInWithAppleObject()
    
    var body: some View {
        NavigationView{
            ZStack {
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
                    Button(action: {
                        signInWithAppleObject.signInWithApple()
                    }, label: {
                        SocialLoginButton(image: Image(uiImage: UIImage(named: "apple_logo")!), text: Text("Continue with Apple"))
                            .padding(.vertical)
                        
                    })
                    
                    // Email Login Section
                    loginCredentialDescription(text: Text("Email"))
                        .padding(.top)
                    
                    InputTextFieldView(text: $vm.credentials.email,
                    placeholder: "Enter Email",
                                       keyboardType: .emailAddress,
                    sfSymbol: "envelope")
                    
                    loginCredentialDescription(text: Text("Password"))
                        .padding(.top)
                    
                    InputPasswordView(password: $vm.credentials.password,
                    placeholder: "Enter Password",
                    sfSymbol: "lock")
                    
                    ButtonView(title: "Login") {
                        vm.login()
                    }
                    .padding(.top, 30)
                    
//                    NavigationLink(destination: SignUpView(), label: {
//                        Text("Create Account")
//                    })
//                    .padding()
//                    .foregroundColor(.blue)
                    
                }
                .padding()
                .alert(isPresented: $vm.hasError,
                       content: {
                    
                    if case .failed(let error) = vm.state {
                        return Alert(
                            title: Text("Error"),
                            message: Text(error.localizedDescription))
                    } else {
                        return Alert(
                        title: Text("Error"),
                        message: Text("Something went wrong"))
                    }
                })
            }
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

//struct SignUpView: View {
//    @State var email = ""
//    @State var password = ""
//
//    @EnvironmentObject var viewModel: AppViewModel
//
//    var body: some View {
//        ZStack {
//            VStack {
//                Text("MyDoc SignUp")
//                    .font(.largeTitle.bold())
//                    .fontWeight(.bold)
//                    .foregroundColor(.gray)
//                    .padding(.bottom, 50)
//
//                TextField("Enter email", text: $email)
//                    .disableAutocorrection(true)
//                    .autocapitalization(.none)
//                    .font(.title3)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .border(Color.gray.opacity(0.7))
//                    .background(Color.white)
//                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
//                //                    .border(.red, width: CGFloat(wrongUsername))
//
//                loginCredentialDescription(text: Text("Password"))
//                    .padding(.top)
//
//                SecureField("Enter password", text: $password)
//                    .disableAutocorrection(true)
//                    .autocapitalization(.none)
//                    .font(.title3)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .border(Color.gray.opacity(0.7))
//                    .background(Color.white)
//                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
//                    .padding(.bottom, 50)
//                //                    .border(.red, width: CGFloat(wrongPassword))
//
//                Button("Sign Up") {
//                    // Authentication
//
//                    guard !email.isEmpty, !password.isEmpty else {
//                        return
//                    }
//
//                    viewModel.signUp(email: email, password: password)
//                }
//                .foregroundColor(Color.black.opacity(0.4))
//                .frame(maxWidth: .infinity, maxHeight: 50)
//                .border(Color.gray.opacity(0.7))
//                .background(Color.gray.opacity(0.4))
//
//            }
//            .padding()
//        }
//    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
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
