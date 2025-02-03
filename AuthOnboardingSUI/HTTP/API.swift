//
//  API.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import Foundation

class API {
    static let shared = API()

    private let baseURL = "https://api.example.com"

    private init() {}

    func fetchUsers(completion: @escaping (Result<[UserM], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else {
            print("Ошибка: Некорректный URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Нет данных"])))
                }
                return
            }

            do {
                let users = try JSONDecoder().decode([UserM].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(users))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }

    func refreshToken(oldToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/refresh") else {
            print("Ошибка: Некорректный URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["token": oldToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Нет данных"])))
                }
                return
            }

            do {
                let response = try JSONDecoder().decode([String: String].self, from: data)
                if let newToken = response["token"] {
                    DispatchQueue.main.async {
                        completion(.success(newToken))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Ошибка обновления токена"])))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}
