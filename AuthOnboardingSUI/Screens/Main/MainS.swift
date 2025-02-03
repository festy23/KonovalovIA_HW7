//
//  MainS.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI

struct MainS: View
{
    @EnvironmentObject var vm: MainVM
    
    var body: some View {
        if vm.navigationState == .Main {
            GeometryReader { geometry in
                VStack {
                    DataV()
                        .foregroundColor(.blue)
                        .padding(0)
                    Spacer()
                    Text("Authorized user screen. Press to logout").onTapGesture {
                        DispatchQueue.main.async {
                            vm.navigationState = .AuthMenu
                            UserDefaults.standard.setValue("", forKey: "token")
                            UserDefaults.standard.synchronize()
                            vm.errorState = .Success(message: "You have successfully logged out of your account.")
                        }
                    }
                    .frame(width: geometry.size.width * 0.95, height: 30)
                    .cornerRadius(5)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .padding(5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5).stroke(Color.blue, lineWidth: 1)
                    }
                }
                .frame(width: geometry.size.width)
                .cornerRadius(5)
                .navigationTitle("Users")
                .padding(0)
            }
        } else {
            AuthMenuS()
        }
    }
}
