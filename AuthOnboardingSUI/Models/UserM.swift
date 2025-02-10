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
            id: Int(self.id),               // Приведение типа (предполагается, что self.id имеет числовой тип)
            username: "",                   // Поле отсутствует в Core Data — оставляем пустым или задаем значение по умолчанию
            password: "",                   // Аналогично
            secretResponse: "",             // Аналогично
            token: "",                      // Аналогично
            firstName: self.firstName ?? "",// Используем значение из Core Data (если опциональное, то заменяем на пустую строку)
            lastName: self.lastName ?? "",
            surname: self.surname ?? "",
            tel: self.tel ?? "",
            tg: self.tg ?? "",
            email: "",                      // Поле отсутствует, оставляем пустым
            avatar: nil                     // Поле отсутствует, оставляем nil
        )
    }
}
