//
//  UserProfileS.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI
import PhotosUI

struct UserProfileS: View {
    @StateObject var vm = UserProfileM()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Username", text: $vm.nickname)
                        .textContentType(.username)
                        .autocapitalization(.none)
                    TextField("Email", text: $vm.email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                }

                Section {
                    HStack {
                        VStack {
                            if case .success(let image) = vm.imageState {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            }

                            PhotosPicker(selection: $vm.imageSelection, matching: .images) {
                                Text("Choose Avatar")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        .frame(width: 120)

                        VStack {
                            TextField("First name", text: $vm.firstName)
                            TextField("Last name", text: $vm.lastName)
                            TextField("Surname", text: $vm.surname)
                        }
                        .padding(.leading)
                    }
                }
                
                Section {
                    TextField("Telegram", text: $vm.tg)
                        .textContentType(.nickname)
                        .autocapitalization(.none)
                    TextField("Phone", text: $vm.tel)
                        .keyboardType(.phonePad)
                }
                
                Section {
                    Button(action: {
                        vm.saveInUserDefaults()
                    }) {
                        Text("Save")
                    }
                    .foregroundColor(.blue)

                    Button(action: {
                        restore(viewModel: vm)
                    }) {
                        Text("Cancel")
                    }
                    .foregroundColor(.gray)
                }

                Section {
                    Button(action: {
                        vm.logout()
                    }) {
                        Text("Log Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("User Profile")
        }
        .onAppear {
            restore(viewModel: vm)
        }
    }
}

@MainActor
func restore(viewModel: UserProfileM) {
    if let data = UserDefaults.standard.data(forKey: "Avatar"),
       let uiImage = UIImage(data: data) {
        viewModel.setImageStateSuccess(image: uiImage)
    } else {
        if let defaultImage = UIImage(named: "Avatar") {
            viewModel.setImageStateSuccess(image: defaultImage)
        }
    }

    // Сохраняем другие данные
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
            print("Unknown value")
        }
    }
}
