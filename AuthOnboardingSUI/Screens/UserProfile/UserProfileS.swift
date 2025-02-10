import SwiftUI
import PhotosUI

struct UserProfileS: View {
    // Локальная модель профиля (предполагается, что UserProfileM уже реализована)
    @StateObject var vm = UserProfileM()
    // Глобальная модель для навигации и текущего пользователя
    @EnvironmentObject var mainVM: MainVM
    
    var body: some View {
        NavigationView {
            Form {
                // Секция с базовой информацией
                Section(header: Text("Account Info")) {
                    TextField("Username", text: $vm.nickname)
                        .textContentType(.username)
                        .autocapitalization(.none)
                    TextField("Email", text: $vm.email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                // Секция с аватаркой и персональными данными
                Section {
                    HStack {
                        // Используем ваш компонент для смены аватара
                        ChangableAvatarV(vm: vm)
                        VStack(alignment: .leading) {
                            TextField("First name", text: $vm.firstName)
                            TextField("Last name", text: $vm.lastName)
                            TextField("Surname", text: $vm.surname)
                        }
                        .padding(.leading)
                    }
                }
                
                // Секция с контактными данными
                Section(header: Text("Contact Info")) {
                    TextField("Telegram", text: $vm.tg)
                        .textContentType(.nickname)
                        .autocapitalization(.none)
                    TextField("Phone", text: $vm.tel)
                        .keyboardType(.phonePad)
                }
                
                // Секция с кнопками Save и Cancel
                Section {
                    Button(action: {
                        vm.saveInUserDefaults()
                    }) {
                        Text("Save")
                    }
                    .foregroundColor(.blue)
                    
                    Button(action: {
                        restore(viewModel: vm)
                        mainVM.navigationState = .Main  // Возвращаем на главный экран (MainS)
                    }) {
                        Text("Cancel")
                    }
                    .foregroundColor(.gray)
                }
                
                // Секция с кнопкой Log Out
                Section {
                    Button(action: {
                        mainVM.logout()
                    }) {
                        Text("Log Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("User Profile")
        }
        .cornerRadius(15)
        .background(Color.white)
        .padding(0)
        .onAppear {
            restore(viewModel: vm)
        }
    }
}

@MainActor
func restore(viewModel: UserProfileM) {
    // Загружаем аватар: если в UserDefaults нет данных, используем стандартную аватарку
    let data = UserDefaults.standard.data(forKey: "Avatar") ?? UIImage(named: "Avatar")!.jpegData(compressionQuality: 1)!
    let image = UIImage(data: data)!
    viewModel.setImageStateSuccess(image: Image(uiImage: image))
    
    for key in viewModel.keyValues {
        switch key {
        case "FirstName":
            viewModel.firstName = UserDefaults.standard.string(forKey: key) ?? ""
        case "LastName":
            viewModel.lastName = UserDefaults.standard.string(forKey: key) ?? ""
        case "Surname":
            viewModel.surname = UserDefaults.standard.string(forKey: key) ?? ""
        case "Email":
            viewModel.email = UserDefaults.standard.string(forKey: key) ?? ""
        case "TG":
            viewModel.tg = UserDefaults.standard.string(forKey: key) ?? ""
        case "Tel":
            viewModel.tel = UserDefaults.standard.string(forKey: key) ?? ""
        case "Nickname":
            viewModel.nickname = UserDefaults.standard.string(forKey: key) ?? ""
        default:
            print("Unknown key: \(key)")
        }
    }
}

struct UserProfileS_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileS()
            .environmentObject(MainVM())
    }
}
