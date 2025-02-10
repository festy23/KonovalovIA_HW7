//
//  UserM.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import Foundation

struct UserM: Codable, Identifiable {
    let id: Int
    let username: String
    let password: String
    let secretResponse: String
    let token: String
    let firstName: String
    let lastName: String
    let surname: String
    let tel: String
    let tg: String
    let email: String
    let avatar: Data?
}

extension User {
    func toUserM() -> UserM {
        return UserM(
            id: Int(self.id),
            username: "",
            password: "",
            secretResponse: "",
            token: "",
            firstName: self.firstName ?? "",
            lastName: self.lastName ?? "",
            surname: self.surname ?? "",
            tel: self.tel ?? "",
            tg: self.tg ?? "",
            email: "",          
            avatar: nil
        )
    }
}
