import SwiftUI

struct DropS: View {
    @EnvironmentObject var vm: MainVM
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    // Локальные состояния для Alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            backgroundGradient
            ScrollView {
                VStack(spacing: 30) {
                    headerView
                    formCard
                    actionButtons
                    Spacer()
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 20)
            }
        }
        .onTapGesture { hideKeyboard() }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Delete account"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - Background
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.red.opacity(0.8)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 10) {
            Image(systemName: "trash.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
            Text("Delete Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text("Enter your credentials to permanently delete your account")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 40)
    }
    
    // MARK: - Form Card
    private var formCard: some View {
        VStack(spacing: 20) {
            TextField("Username", text: $username)
                .padding()
                .background(Color.white.opacity(0.95))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .autocapitalization(.none)
                .onAppear {
                    // Тестовые данные – убрать в продакшене
                    username = "User1"
                    password = "Password1!"
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
                    // Анимация убрана – просто переключаем значение
                    isPasswordVisible.toggle()
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
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 20) {
            // Delete Button
            Button(action: deleteAction) {
                Text("Delete")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .buttonStyle(PressableButtonStyle())
            
            // Back Button
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
    
    // MARK: - Actions
    private func deleteAction() {
        let body: [String: Any] = [
            "username": username,
            "password": password
        ]
        vm.deleteRequest(endpoint: "drop", body: body) { response in
            DispatchQueue.main.async {
                alertMessage = response.token
                showAlert = true
                
                if response.id == 0 {
                    // Удаление успешно
                    KeychainHelper.shared.deleteToken()
                    
                    let keysToRemove = ["username", "email", "firstName", "lastName", "surname", "tg", "tel", "avatar"]
                    for key in keysToRemove {
                        UserDefaults.standard.removeObject(forKey: key)
                    }
                    
                    vm.navigationState = .AuthMenu
                } else {
                    vm.navigationState = .Drop
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

struct DropS_Previews: PreviewProvider {
    static var previews: some View {
        DropS()
            .environmentObject(MainVM())
    }
}
