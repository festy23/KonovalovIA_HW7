//
//  KeychainHelper.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import Security
import Foundation

final class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}

    func save(_ data: Data, service: String, account: String) {
        let query: CFDictionary = [
            kSecValueData as String: data,
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ] as [String: Any] as CFDictionary
        
        if exists(service: service, account: account) {
            update(data, service: service, account: account)
        } else {
            let status = SecItemAdd(query, nil)
            if status != errSecSuccess {
                print("Keychain save error (\(account)): \(status)")
            }
        }
    }
    
    func update(_ data: Data, service: String, account: String) {
        let query: CFDictionary = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ] as [String: Any] as CFDictionary
        
        let attributesToUpdate: CFDictionary = [kSecValueData as String: data] as CFDictionary
        let status = SecItemUpdate(query, attributesToUpdate)
        if status != errSecSuccess {
            print("Keychain update error (\(account)): \(status)")
        }
    }
    
    func read(service: String, account: String) -> Data? {
        let query: CFDictionary = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ] as [String: Any] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        if status == errSecSuccess {
            return result as? Data
        } else {
            print("Keychain read error (\(account)): \(status)")
            return nil
        }
    }
    
    func delete(service: String, account: String) {
        let query: CFDictionary = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ] as [String: Any] as CFDictionary
        
        let status = SecItemDelete(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            print("Keychain delete error (\(account)): \(status)")
        }
    }
    
    func exists(service: String, account: String) -> Bool {
        let query: CFDictionary = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ] as [String: Any] as CFDictionary
        
        let status = SecItemCopyMatching(query, nil)
        return status == errSecSuccess
    }
    
    func clearAll() {
        let query: CFDictionary = [kSecClass as String: kSecClassGenericPassword] as CFDictionary
        let status = SecItemDelete(query)
        if status != errSecSuccess {
            print("Keychain clear error: \(status)")
        }
    }
    
    func saveToken(_ token: String) {
        guard let data = token.data(using: .utf8) else { return }
        save(data, service: "com.yourapp.auth", account: "userToken")
    }
    
    func getToken() -> String? {
        guard let data = read(service: "com.yourapp.auth", account: "userToken") else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func deleteToken() {
        delete(service: "com.yourapp.auth", account: "userToken")
    }
    
    func savePassword(_ password: String, for username: String) {
        guard let data = password.data(using: .utf8) else { return }
        save(data, service: "com.yourapp.auth", account: "password_\(username)")
    }
    
    func getPassword(for username: String) -> String? {
        guard let data = read(service: "com.yourapp.auth", account: "password_\(username)") else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func deletePassword(for username: String) {
        delete(service: "com.yourapp.auth", account: "password_\(username)")
    }
}
