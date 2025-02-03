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
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "email") ?? ""
        let nickname = defaults.string(forKey: "nickname") ?? ""
        let avatar = defaults.data(forKey: "avatar")
        let id = Int(self.id)
        let firstName = self.firstName ?? ""
        let lastName = self.lastName ?? ""
        let surname = self.surname ?? ""
        let tel = self.tel ?? ""
        let tg = self.tg ?? ""
        return UserM(
            id: id,
            username: nickname,
            password: "",
            secretResponse: "",
            token: "",
            firstName: firstName,
            lastName: lastName,
            surname: surname,
            tel: tel,
            tg: tg,
            email: email,
            avatar: avatar
        )
    }
}
