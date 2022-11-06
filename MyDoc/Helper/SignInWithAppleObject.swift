//
//  SignInWithAppleObject.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/05.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import Firebase
import GoogleSignIn

public class SignInWithAppleObject: NSObject {
    // Apple Sign in Properties
    private var currentNonce: String?
    
    // Error Properties
//    @Published var showError: Bool = false
//    @Published var errorMessage: String = ""
    
    // App Log Status
    @AppStorage("log_status") var logStatus: Bool = false
    
    public func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(currentNonce!)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
//    func handleError(error: Error)async{
//        await MainActor.run(body: {
//            errorMessage = error.localizedDescription
//            showError.toggle()
//        })
//    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap{return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension SignInWithAppleObject: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                print("Invalid state: A login callback was received, but no login request was sent.")
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                print("Logged in Success")
                withAnimation(.easeInOut){self.logStatus = true}
            }
        }
        
//        func logGoogleUser(user: GIDGoogleUser){
//            Task{
//                do{
//                    guard let idToken = user.authentication.idToken else{return}
//                    let accesToken = user.authentication.accessToken
//
//                    let credential = OAuthProvider.credential(withProviderID: idToken, accessToken: accesToken)
//
//                    try await Auth.auth().signIn(with: credential)
//
//                    print("Sucess Google!")
//                    await MainActor.run(body: {
//                        withAnimation(.easeInOut){logStatus = true}
//                    })
//                }catch{
//                    await handleError(error: error)
//                }
//            }
//        }
    }
}
