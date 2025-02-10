//
//  AuthVM.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import Foundation
import CoreData
import SwiftUICore
import SwiftUI

class MainVM: ObservableObject {
    private let api = "http://127.0.0.1:7000/api/auth"
    private var serverResponse = RegLogResponse(id: -1, token: "Undefined.")
    
    @Published var navigationState: NavigationState = .Onboarding
    @Published var errorState: ErrorState = .None
    
    @Published var onbordingData = OnbordingM.onbordingData
    
    @Published var loginCounter = 0
    @Published var token = ""
    @Published var data = ""
    @Published var users: [UserM] = []
    @Published var currentUser: UserM? = nil
    @Published var isLoading: Bool = false
    
    // Добавляем colorScheme для использования в preferredColorScheme
    @Published var colorScheme: ColorScheme = .light
    
    init() {
        if !UserDefaults.standard.bool(forKey: "onboardingDone") {
            self.navigationState = .Onboarding
        } else {
            if let storedToken = UserDefaults.standard.string(forKey: "token"), !storedToken.isEmpty {
                self.token = storedToken
                self.navigationState = .Main
            } else {
                self.navigationState = .AuthMenu
            }
        }
        
        loadUsers()
        if !token.isEmpty {
            syncUsers()
        }
    }
    
    // MARK: - Работа с паролем
    private func validatePassword(password: String) -> Bool {
        let control = #"(?=.{8,})(?=.*[a-zA-Z])(?=.*\d)(?=.*[!#$%&? "])"#
        return password.range(of: control, options: .regularExpression) != nil
    }
    
    func autoFillPassword(for username: String) {
        if let savedPassword = KeychainHelper.shared.getPassword(for: username) {
            print("Auto-filled password for \(username): \(savedPassword)")
        }
    }
    
    // MARK: - Тема
    func loadTheme() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        colorScheme = isDarkMode ? .dark : .light
    }
    
    func toggleTheme() {
        let newMode = !UserDefaults.standard.bool(forKey: "isDarkMode")
        UserDefaults.standard.set(newMode, forKey: "isDarkMode")
        colorScheme = newMode ? .dark : .light
    }
    
    func postRequest(endpoint: String,
                     body: [String: Any],
                     callback: @escaping (RegLogResponse) -> Void) {
        guard let url = URL(string: "\(api)/\(endpoint)") else {
            DispatchQueue.main.async {
                self.errorState = .Error(message: "Invalid URL")
                // Возвращаем сообщение об ошибке через callback
                callback(RegLogResponse(id: -1, token: "Invalid URL"))
            }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: error.localizedDescription)
                    // Если ошибка, возвращаем через callback
                    callback(RegLogResponse(id: -1, token: error.localizedDescription))
                }
                return
            }
            guard let datas = data else {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: "No data received")
                    callback(RegLogResponse(id: -1, token: "No data received"))
                }
                return
            }
            do {
                let decoded = try JSONDecoder().decode(RegLogResponse.self, from: datas)
                DispatchQueue.main.async {
                    if decoded.id < 0 {
                        self.errorState = .Error(message: decoded.token)
                    } else {
                        // Успешный результат, токен сохраняем при необходимости
                        self.token = decoded.token
                    }
                    callback(decoded) // Возвращаем результат на SignupS
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: error.localizedDescription)
                    callback(RegLogResponse(id: -1, token: error.localizedDescription))
                }
            }
        }.resume()
    }

    func deleteRequest(endpoint: String,
                       body: [String: Any],
                       callback: @escaping (RegLogResponse) -> Void) {
        guard let url = URL(string: "\(api)/\(endpoint)") else {
            DispatchQueue.main.async {
                self.errorState = .Error(message: "Invalid URL")
                callback(RegLogResponse(id: -1, token: "Invalid URL"))
            }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: error.localizedDescription)
                    callback(RegLogResponse(id: -1, token: error.localizedDescription))
                }
                return
            }
            guard let datas = data else {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: "No data received")
                    callback(RegLogResponse(id: -1, token: "No data received"))
                }
                return
            }
            do {
                let decoded = try JSONDecoder().decode(RegLogResponse.self, from: datas)
                DispatchQueue.main.async {
                    if decoded.id < 0 {
                        self.errorState = .Error(message: decoded.token)
                    } else {
                        
                        self.token = ""
                    }
                    callback(decoded)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: error.localizedDescription)
                    callback(RegLogResponse(id: -1, token: error.localizedDescription))
                }
            }
        }.resume()
    }
    
    // MARK: - Logout
    func logout() {
        KeychainHelper.shared.deleteToken()
        token = ""
        navigationState = .AuthMenu
    }
    
    
    func getUsers(token: String, completion: @escaping ([UserM]) -> Void) {
        guard let url = URL(string: "\(api)/users") else {
            completion([])
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorState = .Error(message: error.localizedDescription)
                    self.users = []
                    completion([])
                    return
                }
                guard let datas = data else {
                    self.errorState = .Error(message: "No data received from server")
                    self.users = []
                    completion([])
                    return
                }
                do {
                    let fetchedUsers = try JSONDecoder().decode([UserM].self, from: datas)
                    self.users = fetchedUsers
                    completion(fetchedUsers)
                } catch {
                    self.errorState = .Error(message: error.localizedDescription)
                    self.users = []
                    completion([])
                }
            }
        }.resume()
    }
    
    func getRegisteredUsers(completion: @escaping ([UserM]) -> Void) {
        if token.isEmpty {
            completion([])
        } else {
            getUsers(token: token, completion: completion)
        }
    }
    
    
    func syncUsers(completion: (() -> Void)? = nil) {
        guard !token.isEmpty, let url = URL(string: "\(api)/users") else {
            DispatchQueue.main.async { completion?() }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        DispatchQueue.main.async { self.isLoading = true }
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorState = .Error(message: error.localizedDescription)
                    completion?()
                    return
                }
                guard let data = data else {
                    self.errorState = .Error(message: "No data received from server during sync")
                    completion?()
                    return
                }
                do {
                    let serverUsers = try JSONDecoder().decode([UserM].self, from: data)
                    self.users = serverUsers
                    completion?()
                } catch {
                    self.errorState = .Error(message: error.localizedDescription)
                    completion?()
                }
            }
        }.resume()
    }
    
    
    func getCurrentUser(completion: @escaping (UserM?) -> Void) {
        guard !token.isEmpty, let url = URL(string: "\(api)/user") else {
            completion(nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorState = .Error(message: error.localizedDescription)
                    completion(nil)
                    return
                }
                guard let data = data else {
                    self.errorState = .Error(message: "No data received from server")
                    completion(nil)
                    return
                }
                do {
                    let currentUser = try JSONDecoder().decode(UserM.self, from: data)
                    self.currentUser = currentUser
                    completion(currentUser)
                } catch {
                    self.errorState = .Error(message: error.localizedDescription)
                    completion(nil)
                }
            }
        }.resume()
    }
    
    
    func updateUserProfile(updatedUser: UserM, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(api)/updateProfile") else {
            DispatchQueue.main.async {
                self.errorState = .Error(message: "Invalid URL for updating profile")
            }
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let body: [String: Any] = [
            "id": updatedUser.id,
            "firstName": updatedUser.firstName,
            "lastName": updatedUser.lastName,
            "surname": updatedUser.surname,
            "tel": updatedUser.tel,
            "tg": updatedUser.tg
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            DispatchQueue.main.async {
                self.errorState = .Error(message: "Failed to serialize profile update body")
            }
            completion(false)
            return
        }
        DispatchQueue.main.async { self.isLoading = true }
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorState = .Error(message: error.localizedDescription)
                    completion(false)
                    return
                }
                guard let data = data else {
                    self.errorState = .Error(message: "No data received from server during profile update")
                    completion(false)
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(RegLogResponse.self, from: data)
                    if decodedResponse.id > 0 {
                        completion(true)
                    } else {
                        self.errorState = .Error(message: "Failed to update profile")
                        completion(false)
                    }
                } catch {
                    self.errorState = .Error(message: error.localizedDescription)
                    completion(false)
                }
            }
        }.resume()
    }
    
    // MARK: - Загрузка локальных пользователей (если используется Core Data)
    func loadUsers() {
        let localUsers = PersistenceController.shared.getAllUsers()
        self.users = localUsers.map { $0.toUserM() }
    }
    
    func refreshUsers() {
        syncUsers()
    }
    
    // MARK: - Универсальный GET-запрос (опционально)
    var getRequest: (String, [String: Any], String, String, @escaping (RegLogResponse) -> Void) -> Void {
        return { endpoint, body, token, requestType, callback in
            guard let url = URL(string: "\(self.api)/\(endpoint)") else {
                DispatchQueue.main.async { self.errorState = .Error(message: "Invalid URL") }
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = requestType
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if !body.isEmpty {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: body)
                } catch {
                    DispatchQueue.main.async { self.errorState = .Error(message: "Failed to serialize request body") }
                    return
                }
            }
            DispatchQueue.main.async { self.isLoading = true }
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async { self.isLoading = false }
                if let error = error {
                    DispatchQueue.main.async { self.errorState = .Error(message: error.localizedDescription) }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async { self.errorState = .Error(message: "No data received from server") }
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(RegLogResponse.self, from: data)
                    DispatchQueue.main.async {
                        callback(decodedResponse)
                    }
                } catch {
                    DispatchQueue.main.async { self.errorState = .Error(message: error.localizedDescription) }
                }
            }.resume()
        }
    }
}
