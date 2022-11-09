//
//  LoginViewModel.swift
//  MyDoc
//
//  Created by Derek Kim on 2022/11/06.
//

import Foundation
import Combine

enum LoginState {
    case successful
    case failed(error: Error)
    case na
}

protocol LoginViewModel {
    func login()
    var service: LoginService { get }
    var state: LoginState { get }
    var credentials: LoginCredentials { get }
    var hasError: Bool { get }
    init(service: LoginService)
}

final class LoginViewModelImpl: ObservableObject, LoginViewModel {
    
    @Published var loginResponse: LoginResponse? = nil
    @Published var hasError: Bool = false
    @Published var state: LoginState = .na
    @Published var credentials: LoginCredentials = LoginCredentials.new
    @Published var logincredentialsencodable: LoginCredentialsEncodable? = nil
    
    private var subscriptions = Set<AnyCancellable>()
    
    let service: LoginService
    
    init(service: LoginService) {
        self.service = service
        setupErrorSubscriptions()
    }
    
    func login() {
        
        service
            .login(with: credentials)
            .sink { res in
                
                switch res {
                case .failure(let err):
                    self.state = .failed(error: err)
                default: break
                }
                
            } receiveValue: { [weak self] in
                self?.state = .successful
            }
            .store(in: &subscriptions)
    }
    
    func loginSample (){
        guard let url = URL(string: "/api/login") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let encodeData = try encoder.encode(logincredentialsencodable)
            urlRequest.httpBody = encodeData
        } catch {
            print(error.localizedDescription)
            return
        }
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let response = response, let HTTPResponse = response as? HTTPURLResponse {
                if HTTPResponse.statusCode != 200 {
                    print("Bad Response")
                    return
                } else if HTTPResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let loginData = try decoder.decode(LoginResponse.self, from: data)
                            self.loginResponse = loginData
                        } catch {
                            print(error.localizedDescription)
                            return
                        }
                    }
                }
            }
        }
        .resume()
    }
}

private extension LoginViewModelImpl {
    
    func setupErrorSubscriptions() {
        $state
            .map { state -> Bool in
                switch state {
                case .successful,
                        .na:
                    return false
                case .failed:
                    return true
                }
            }
            .assign(to: &$hasError)
    }
}
