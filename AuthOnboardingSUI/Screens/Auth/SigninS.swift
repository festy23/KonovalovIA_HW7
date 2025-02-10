import SwiftUI

struct SigninS: View {
    @EnvironmentObject var vm: MainVM
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        ZStack {
            backgroundView
            content
        }
        .navigationBarHidden(true)
        .onTapGesture { hideKeyboard() }
    }
    
    
    private var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.green.opacity(0.8)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var content: some View {
        ScrollView {
            VStack(spacing: 30) {
                header
                formCard
                actionButtons
                Spacer()
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
        }
    }
    
    
    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text("Access your account")
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.top, 40)
    }
    
    
    private var formCard: some View {
        VStack(spacing: 20) {
            TextField("Username", text: $username, onCommit: {
                vm.autoFillPassword(for: username)
            })
            .padding()
            .background(Color.white.opacity(0.95))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .autocapitalization(.none)
            
            ZStack(alignment: .trailing) {
                Group {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.95))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                Button(action: {
                    withAnimation {
                        isPasswordVisible.toggle()
                    }
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
    
    private var actionButtons: some View {
        VStack(spacing: 20) {
            Button(action: loginAction) {
                Text("Login")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .buttonStyle(PressableButtonStyle())
            
            Button(action: backAction) {
                Text("Back")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .buttonStyle(PressableButtonStyle())
        }
    }
    
    
    private func loginAction() {
        let body: [String: Any] = [
            "username": username,
            "password": password
        ]
        vm.postRequest(endpoint: "signin", body: body) { response in
            if response.id >= 0 {
                KeychainHelper.shared.savePassword(password, for: username)
                KeychainHelper.shared.saveToken(response.token)
                
                vm.navigationState = .Main
                vm.errorState = .Success(message: "You are signed in successfully.")
            } else {
                vm.navigationState = .Signin
                vm.errorState = .Error(message: response.token)
            }
        }
    }
    
    private func backAction() {
        vm.navigationState = .AuthMenu
    }
    
    private func hideKeyboard() {
        UIApplication.shared.endEditing()
    }
}

struct SigninS_Previews: PreviewProvider {
    static var previews: some View {
        SigninS()
            .environmentObject(MainVM())
    }
}
