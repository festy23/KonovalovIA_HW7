//
//  AuthMenu.swift
//  AuthOnboardingSUI
//  Created by B.RF Group on 17.01.2025.
//
import SwiftUI

struct AuthMenuS: View {
    @EnvironmentObject var vm: MainVM
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Button {
                        vm.navigationState = .Signin
                    } label: {
                        Text("Sign in")
                            .font(.system(size: 25, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.green)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
                    }
                    .frame(width: 300)
                    
                    Button {
                        vm.navigationState = .Reset
                    } label: {
                        Text("Reset password")
                            .font(.system(size: 25, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
                    }
                    .frame(width: 300)
                    
                    Button {
                        vm.navigationState = .Signup
                    } label: {
                        Text("Sign up")
                            .font(.system(size: 25, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
                    }
                    .frame(width: 300)
                    
                    Button {
                        vm.navigationState = .Drop
                    } label: {
                        Text("Delete account")
                            .font(.system(size: 25, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
                    }
                    .frame(width: 300)
                }
                .padding()
            }
            .navigationTitle("Auth Menu")
        }
    }
}

struct AuthMenuS_Previews: PreviewProvider {
    static var previews: some View {
        AuthMenuS()
            .environmentObject(MainVM())
    }
}
