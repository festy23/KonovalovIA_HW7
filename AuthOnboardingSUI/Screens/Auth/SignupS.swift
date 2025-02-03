//
//  SignupS.swift
//  AuthSUI8
//  Created by brfsu on 19.03.2024.
//
import SwiftUI

struct SignupS: View
{
    @EnvironmentObject var vm: MainVM
    
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var secretResponse = ""
    @State private var isPasswordVisible = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 20) {
                TextField("User name", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).onAppear {
                        username = "User1"
                        password = "Password1!"
                        email = "Advev@mail.ru"
                        secretResponse = "123"
                    }
                
                PasswordTextFieldV("Password", text: $password, isSecure: !isPasswordVisible)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay {
                        HStack {
                            Spacer()
                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 8)
                        }
                    }
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Response on the secret question", text: $secretResponse)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Defining registration button
                Button {
                    let body: [String: Any] = [
                        "username": username,
                        "password": password,
                        "email": email,
                        "secretResponse": secretResponse
                    ]
                    vm.postRequest(endpoint: "signup", body: body, callback: { response in
                        DispatchQueue.main.async {
                            if response.id > 0 { // ok
                                vm.navigationState = .Main
                                vm.errorState = .Success(message: "You are registered successfully.")
                                UserDefaults.standard.setValue(response.token, forKey: "token")
                                UserDefaults.standard.synchronize()
                            } else { // some error
                                vm.navigationState = .Signup
                                vm.errorState = .Error(message: response.token)
                            }
                        }
                    })
                } label: {
                    Text("Register")
                        .font(.system(size: 25, weight: .bold))
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .foregroundColor(.yellow)
                        .cornerRadius(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 5)
                        }
                }
                
                Button {
                    vm.navigationState = .AuthMenu
                } label: {
                    Text("Back")
                        .font(.system(size: 25, weight: .bold))
                        .frame(width: 200, height: 40)
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .onTapGesture {
            endEditing()
        }
    }
    
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}
