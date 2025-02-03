//
//  ResetS.swift
//  AuthSUI8
//  Created by brfsu on 19.03.2024.
//
import SwiftUI

struct ResetS: View {
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
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onAppear {
                        username = "User1"
                        password = "Password1!"
                        email = "Advev@mail.ru"
                        secretResponse = "123"
                    }
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Response on the secret question", text: $secretResponse)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                PasswordTextFieldV("New password", text: $password, isSecure: !isPasswordVisible)
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
                
                Button {
                    let body: [String: Any] = [
                        "username": username,
                        "password": password,
                        "email": email,
                        "secretResponse": secretResponse
                    ]
                    vm.postRequest(endpoint: "reset", body: body, callback: { response in
                        DispatchQueue.main.async {
                            if response.id == 0 {
                                username = ""
                                password = ""
                                email = ""
                                secretResponse = ""
                                vm.navigationState = .AuthMenu // .Reset
                                vm.errorState = .Success(message: "Password successfully changed.")
                            } else {
                                vm.errorState = .Error(message: "An error occurred while changing your password.")
                                // vm.navigationState = .Reset
                            }
                        }
                    })
                } label: {
                    Text("Reset")
                        .font(.system(size: 25, weight: .bold))
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .foregroundColor(.blue)
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
                        .background(Color.blue)
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
