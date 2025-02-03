//
//  ProfileImageV.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI
import PhotosUI
import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject var profileVM = UserProfileM()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Аватар с кнопкой выбора изображения
                ZStack(alignment: .bottomTrailing) {
                    ProfileImageV(imageState: profileVM.imageState)
                    PhotosPicker(selection: $profileVM.imageSelection, matching: .images) {
                        Image(systemName: "camera.fill")
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .offset(x: -8, y: -8)
                }
                .padding(.top, 20)
                
                // Редактируемые поля профиля
                Group {
                    EditableRow(title: "First Name", text: $profileVM.firstName)
                    EditableRow(title: "Last Name", text: $profileVM.lastName)
                    EditableRow(title: "Surname", text: $profileVM.surname)
                    EditableRow(title: "Tel", text: $profileVM.tel)
                    EditableRow(title: "TG", text: $profileVM.tg)
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.vertical)
                
                // Только для просмотра поля профиля
                Group {
                    ReadOnlyRow(title: "Username", value: profileVM.nickname)
                    ReadOnlyRow(title: "Email", value: profileVM.email)
                    ReadOnlyRow(title: "Password", value: "******")
                    ReadOnlyRow(title: "Secret Response", value: "********")
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("My Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    profileVM.saveInUserDefaults()
                }
            }
        }
        .onAppear {
            profileVM.loadAvatar()
            profileVM.firstName = UserDefaults.standard.string(forKey: "FirstName") ?? ""
            profileVM.lastName = UserDefaults.standard.string(forKey: "LastName") ?? ""
            profileVM.surname = UserDefaults.standard.string(forKey: "Surname") ?? ""
            profileVM.tel = UserDefaults.standard.string(forKey: "Tel") ?? ""
            profileVM.tg = UserDefaults.standard.string(forKey: "TG") ?? ""
            profileVM.email = UserDefaults.standard.string(forKey: "Email") ?? ""
            profileVM.nickname = UserDefaults.standard.string(forKey: "Nickname") ?? "User"
        }
    }
}

struct EditableRow: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            TextField(title, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct ReadOnlyRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title + ":")
                .bold()
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}

struct ProfileImageV: View {
    let imageState: UserProfileM.ImageState

    var body: some View {
        Group {
            switch imageState {
            case .empty:
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.gray)
            case .loading(let progress):
                ZStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.gray)
                    ProgressView(value: progress.fractionCompleted)
                        .progressViewStyle(CircularProgressViewStyle())
                }
            case .success(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            case .failure:
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.red)
            }
        }
        .frame(width: 120, height: 120)
        .clipShape(Circle())
    }
}

struct ProfileImageV_Previews: PreviewProvider {
    static var previews: some View {
        
        ProfileImageV(imageState: .empty)
    }
}
