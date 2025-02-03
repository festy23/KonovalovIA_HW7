//
//  UserDetailView.swift
//  AuthOnboardingSUI
//
//  Created by IvanM3 on 03.02.2025.
//

import SwiftUI

struct UserDetailView: View {
    let user: UserM
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                UserAvatarView(imageData: user.avatar)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .padding(.top, 20)
                
                Group {
                    DetailRow(title: "Username", value: user.username)
                    DetailRow(title: "Email", value: user.email)
                    DetailRow(title: "First Name", value: user.firstName)
                    DetailRow(title: "Last Name", value: user.lastName)
                    DetailRow(title: "Surname", value: user.surname)
                    DetailRow(title: "Tel", value: user.tel)
                    DetailRow(title: "TG", value: user.tg)
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle(user.username)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    var body: some View {
        HStack {
            Text(title + ":")
                .bold()
            Spacer()
            Text(value)
        }
        .padding(.vertical, 4)
    }
}
