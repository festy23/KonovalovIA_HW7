//
//  UsersListView.swift
//  AuthOnboardingSUI
//
//  Created by IvanM3 on 03.02.2025.
//

import SwiftUI

struct UsersListView: View {
    @EnvironmentObject var vm: MainVM
    
    var body: some View {
        List(vm.users) { user in
            NavigationLink(destination: UserDetailView(user: user)) {
                HStack(spacing: 12) {
                    UserAvatarView(imageData: user.avatar)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(user.username)
                            .font(.headline)
                        Text("\(user.firstName) \(user.lastName)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Users")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    
                    vm.refreshUsers()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}

struct UserAvatarView: View {
    let imageData: Data?
    
    var body: some View {
        if let data = imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFill()
                .foregroundColor(.gray)
        }
    }
}
