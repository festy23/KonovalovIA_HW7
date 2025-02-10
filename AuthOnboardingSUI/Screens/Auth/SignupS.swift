import SwiftUI

struct SignupS: View {
    @EnvironmentObject var vm: MainVM

    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var secretResponse = ""
    @State private var isPasswordVisible = false

    // Показывается Alert
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            // Градиентный фон
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    header
                    formCard
                    actionButtons
                    Spacer()
                }
                .padding(.vertical, 30)
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing() // скрытие клавиатуры
        }
        // Привязка алерта
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Registration"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text("Register to join us")
                .foregroundColor(.white.opacity(0.8))
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
                    // ТЕСТОВО
                    username = "User1"
                    password = "Password1!"
                    email = "advev@mail.ru"
                    secretResponse = "123"
                }
            
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
    }
    
    private var actionButtons: some View {
        VStack(spacing: 20) {
            Button(action: registerAction) {
                Text("Register")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .buttonStyle(PressableButtonStyle())
            
            Button(action: {
                vm.navigationState = .AuthMenu
            }) {
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

    private func registerAction() {
        let body: [String: Any] = [
            "username": username,
            "password": password,
            "email": email,
            "secretResponse": secretResponse
        ]
        vm.postRequest(endpoint: "signup", body: body) { response in
            DispatchQueue.main.async {
                alertMessage = response.token
                showAlert = true
                if response.id > 0 {
                    vm.navigationState = .AuthMenu
                } else {
                    vm.navigationState = .Signup
                }
            }
        }
    }
}
