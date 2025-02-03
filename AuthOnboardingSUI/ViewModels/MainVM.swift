import Foundation
import CoreData
import SwiftUICore
import SwiftUI

class MainVM: ObservableObject {
    private let api = "http://127.0.0.1:7000/api/auth"
    
    @Published var navigationState: NavigationState = .Onboarding
    @Published var colorScheme: ColorScheme = .light
    @Published var errorState: ErrorState = .None
    @Published var onbordingData = OnbordingM.onbordingData
    @Published var loginCounter = 0
    @Published var token = ""
    @Published var data = ""
    @Published var users: [UserM] = []
    @Published var isLoading: Bool = false
    @Published var autoFilledPassword: String = ""
    
    init() {
        loadTheme()
        if !UserDefaults.standard.bool(forKey: "onboardingDone") {
            navigationState = .Onboarding
        } else if let savedToken = KeychainHelper.shared.getToken(), !savedToken.isEmpty {
            token = savedToken
            navigationState = .Main
        } else {
            navigationState = .AuthMenu
        }
        loadUsers()
        if !token.isEmpty {
            syncUsers()
        }
    }
    
    func autoFillPassword(for username: String) {
        if let savedPassword = KeychainHelper.shared.getPassword(for: username) {
            DispatchQueue.main.async {
                self.autoFilledPassword = savedPassword
            }
        }
    }
    
    func loadTheme() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        colorScheme = isDarkMode ? .dark : .light
    }
    
    func toggleTheme() {
        let newMode = (colorScheme == .light)
        UserDefaults.standard.set(newMode, forKey: "isDarkMode")
        colorScheme = newMode ? .dark : .light
    }
    
    private func validatePassword(_ password: String) -> Bool {
        let regex = #"(?=.{8,})(?=.*[A-Za-z])(?=.*\d)(?=.*[!#$%&? "])"#
        return password.range(of: regex, options: .regularExpression) != nil
    }
    
    func postRequest(endpoint: String = "signin",
                     body: [String: Any],
                     callback: @escaping (RegLogResponse) -> Void) {
        guard let url = URL(string: "\(api)/\(endpoint)") else {
            DispatchQueue.main.async { self.errorState = .Error(message: "Invalid URL") }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            DispatchQueue.main.async { self.errorState = .Error(message: "Failed to serialize request body") }
            return
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
                    if decodedResponse.id < 0 {
                        self.errorState = .Error(message: decodedResponse.token)
                    } else {
                        KeychainHelper.shared.saveToken(decodedResponse.token)
                        self.token = decodedResponse.token
                        self.navigationState = .Main
                        callback(decodedResponse)
                    }
                }
            } catch {
                DispatchQueue.main.async { self.errorState = .Error(message: error.localizedDescription) }
            }
        }.resume()
    }
    
    func logout() {
        KeychainHelper.shared.deleteToken()
        token = ""
        navigationState = .AuthMenu
    }
    
    func getUsers(token: String, completion: @escaping ([UserM]) -> Void) {
        guard let url = URL(string: "\(api)/users") else {
            DispatchQueue.main.async {
                self.errorState = .Error(message: "Invalid URL for users")
                completion([])
            }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        DispatchQueue.main.async { self.isLoading = true }
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { self.isLoading = false }
            if let error = error {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: error.localizedDescription)
                    self.users = []
                    completion([])
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: "No data received from server")
                    self.users = []
                    completion([])
                }
                return
            }
            do {
                let fetchedUsers = try JSONDecoder().decode([UserM].self, from: data)
                DispatchQueue.main.async {
                    self.errorState = .Success(message: "Users data retrieved successfully.")
                    self.users = fetchedUsers
                    completion(fetchedUsers)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: error.localizedDescription)
                    self.users = []
                    completion([])
                }
            }
        }.resume()
    }
    
    func syncUsers(completion: (() -> Void)? = nil) {
        guard !token.isEmpty, let url = URL(string: "\(api)/users") else {
            DispatchQueue.main.async { completion?() }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        DispatchQueue.main.async { self.isLoading = true }
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { self.isLoading = false }
            if let error = error {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: error.localizedDescription)
                    completion?()
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: "No data received from server during sync")
                    completion?()
                }
                return
            }
            do {
                let serverUsers = try JSONDecoder().decode([UserM].self, from: data)
                DispatchQueue.main.async {
                    self.users = serverUsers
                    PersistenceController.shared.syncUsers(with: serverUsers)
                    completion?()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: error.localizedDescription)
                    completion?()
                }
            }
        }.resume()
    }
    
    func loadUsers() {
        let localUsers = PersistenceController.shared.getAllUsers()
        self.users = localUsers.map { $0.toUserM() }
    }
    
    func refreshUsers() {
        syncUsers()
    }
    
    func updateUserProfile(updatedUser: UserM, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(api)/updateProfile") else {
            DispatchQueue.main.async { self.errorState = .Error(message: "Invalid URL for updating profile") }
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
            DispatchQueue.main.async { self.errorState = .Error(message: "Failed to serialize profile update body") }
            completion(false)
            return
        }
        DispatchQueue.main.async { self.isLoading = true }
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { self.isLoading = false }
            if let error = error {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: error.localizedDescription)
                    completion(false)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: "No data received from server during profile update")
                    completion(false)
                }
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(RegLogResponse.self, from: data)
                DispatchQueue.main.async {
                    if decodedResponse.id > 0 {
                        PersistenceController.shared.upsertUser(updatedUser)
                        self.loadUsers()
                        completion(true)
                    } else {
                        self.errorState = .Error(message: "Failed to update profile")
                        completion(false)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorState = .Error(message: error.localizedDescription)
                    completion(false)
                }
            }
        }.resume()
    }
}
