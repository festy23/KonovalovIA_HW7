import SwiftUI

struct ResetS: View {
    @EnvironmentObject var vm: MainVM
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var secretResponse: String = ""
    @State private var password: String = ""
    
    @State private var isPasswordVisible = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            backgroundView
            content
        }
        .onTapGesture { hideKeyboard() }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Password Reset"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarHidden(true)
    }
    
    private var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.yellow.opacity(0.8)]),
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
            Image(systemName: "lock.rotation")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
            
            Text("Reset Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Enter username, email, response on the secret question and new password")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 40)
    }
    
    private var formCard: some View {
        VStack(spacing: 20) {
            TextField("User name", text: $username)
                .padding()
                .background(Color.white.opacity(0.95))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .autocapitalization(.none)
                .onAppear {
                    username = "User1"
                }
            
            ZStack(alignment: .trailing) {
                Group {
                    if isPasswordVisible {
                        TextField("New Password", text: $password)
                    } else {
                        SecureField("New Password", text: $password)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.95))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                Button(action: {
                    withAnimation { isPasswordVisible.toggle() }
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            }
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.white.opacity(0.95))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .autocapitalization(.none)
            
            TextField("Response on the secret question", text: $secretResponse)
                .padding()
                .background(Color.white.opacity(0.95))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .onAppear {
            email = "Advev@mail.ru"
            secretResponse = "123"
            password = "Password2!"
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 20) {
            Button(action: resetAction) {
                Text("Reset Password")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
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
        .padding(.horizontal, 20)
    }

    private func resetAction() {
        let body: [String: Any] = [
            "username": username,
            "email": email,
            "secretResponse": secretResponse,
            "password": password
        ]
        
        vm.postRequest(endpoint: "reset", body: body) { response in
            DispatchQueue.main.async {
                alertMessage = response.token
                showAlert = true
                
                if response.id == 0 {
                    vm.navigationState = .AuthMenu
                } else {
                    vm.navigationState = .Reset
                }
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

struct ResetS_Previews: PreviewProvider {
    static var previews: some View {
        ResetS()
            .environmentObject(MainVM())
    }
}
