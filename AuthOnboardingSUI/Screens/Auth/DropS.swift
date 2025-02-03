import SwiftUI

struct DropS: View {
    @EnvironmentObject var vm: MainVM
    @State private var username = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 20) {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onAppear {
                        username = "User1"
                        password = "Password1!"
                    }
                PasswordTextFieldV("Password", text: $password, isSecure: !isPasswordVisible)
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
                        "password": password
                    ]
                    vm.postRequest(endpoint: "drop", body: body) { response in
                        if response.id == 0 {
                            username = ""
                            password = ""
                            vm.navigationState = .AuthMenu
                            vm.errorState = .Success(message: response.token)
                        } else {
                            vm.navigationState = .Drop
                            vm.errorState = .Error(message: response.token)
                        }
                    }
                } label: {
                    Text("Delete")
                        .font(.system(size: 25, weight: .bold))
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .foregroundColor(.red)
                        .cornerRadius(10)
                }
                Button {
                    vm.navigationState = .AuthMenu
                } label: {
                    Text("Back")
                        .font(.system(size: 25, weight: .bold))
                        .frame(width: 200, height: 40)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .onTapGesture { UIApplication.shared.endEditing() }
    }
}

