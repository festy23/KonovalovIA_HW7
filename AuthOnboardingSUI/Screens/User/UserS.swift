//
//  UserS.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI

import SwiftUI

struct UserS: View {
    @State var user: UserM

    var body: some View {
        VStack {
            Text(user.token)
                .foregroundColor(.green)
            Spacer()
        }
        .navigationTitle("\(user.username)'s token")
    }
}
