//
//  PasswordTextFieldV.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI

struct PasswordTextFieldV: View
{
    private var title: String
    @Binding private var text: String
    private var isSecure: Bool

    init(_ title: String, text: Binding<String>, isSecure: Bool) {
        self.title = title
        self._text = text
        self.isSecure = isSecure
    }
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(title, text: $text)
            } else {
                TextField(title, text: $text)
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}
