//
//  AuthOnboardingSUIApp.swift
//  AuthOnboardingSUI
//  Created by brfsu
//

import SwiftUI
import Foundation

@main
struct AuthOnboardingSUIApp: App {
    @StateObject var vm = MainVM()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .preferredColorScheme(vm.colorScheme)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var vm: MainVM

    var body: some View {
        switch vm.navigationState {
        case .Onboarding:
            OnboardingS(onbordingData: vm.onbordingData) {
                vm.navigationState = .AuthMenu
            }
        case .AuthMenu:
            AuthMenuS()
        case .Signin:
            SigninS()
        case .Signup:
            SignupS()
        case .Main:
            DataV()
        case .Reset:
            ResetS()
        case .Drop:
            DropS()
        }
    }
}
