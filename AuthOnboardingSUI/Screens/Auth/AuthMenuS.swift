//
//  AuthMenu.swift
//  AuthOnboardingSUI
//  Created by B.RF Group on 17.01.2025.
//
import SwiftUI

struct AuthMenuS: View {
    @EnvironmentObject var vm: MainVM
    @State private var animateContent = false

    var body: some View {
        NavigationView {
            ZStack {
                // Градиентный фон
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Image(systemName: "shield.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                        
                        Text("MyRegisterApp!!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Choose an option")
                            .foregroundColor(.white)
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        AuthMenuButton(
                            title: "Sign In",
                            backgroundColor: Color.white.opacity(0.9),
                            foregroundColor: .blue
                        ) {
                            vm.navigationState = .Signin
                        }
                        
                        AuthMenuButton(
                            title: "Reset Password",
                            backgroundColor: Color.white.opacity(0.9),
                            foregroundColor: .blue
                        ) {
                            vm.navigationState = .Reset
                        }
                        
                        AuthMenuButton(
                            title: "Sign Up",
                            backgroundColor: Color.white.opacity(0.9),
                            foregroundColor: .blue
                        ) {
                            vm.navigationState = .Signup
                        }
                        
                        AuthMenuButton(
                            title: "Delete Account",
                            backgroundColor: Color.white.opacity(0.9),
                            foregroundColor: .red
                        ) {
                            vm.navigationState = .Drop
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
                
                .opacity(animateContent ? 1 : 0)
                .animation(.easeOut(duration: 0.5), value: animateContent)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            animateContent = true
        }
    }
}


struct AuthMenuButton: View {
    let title: String
    let backgroundColor: Color
    let foregroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}

struct AuthMenuS_Previews: PreviewProvider {
    static var previews: some View {
        AuthMenuS()
            .environmentObject(MainVM())
    }
}

// MARK: стиль для анимации нажатия кнопок
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
