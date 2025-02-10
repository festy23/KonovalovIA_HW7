//
//  MainAuthS.swift
//  AuthSUI8
//  Created by brfsu on 13.03.2024.
//
import SwiftUI

struct ScreenSwitcherS: View {
    @EnvironmentObject var vm: MainVM
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 20) {
                switch vm.navigationState {
                case .Onboarding:
                    OnboardingS(onbordingData: OnbordingM.onbordingData) {
                        UserDefaults.standard.setValue(true, forKey: "onboardingDone")
                        UserDefaults.standard.synchronize()
                        vm.navigationState = .AuthMenu
                    }
                case .Main:
                    MainS()
                case .Signin:
                    SigninS()
                case .Signup:
                    SignupS()
                case .Reset:
                    ResetS()
                case .Drop:
                    DropS()
                case .AuthMenu:
                    AuthMenuS()
                }
            }
        }
        .padding()
        .overlay(ErrorV())
        .onAppear {
            
            vm.getRequest("check", [:], vm.token, "GET") { response in
                DispatchQueue.main.async {
                    if response.id == -1 {
                        if vm.navigationState != .Onboarding {
                            vm.errorState = .Error(message: response.token)
                            vm.navigationState = .AuthMenu
                        }
                    } else {
                        vm.navigationState = .Main
                    }
                }
            }
        }
    }
}
