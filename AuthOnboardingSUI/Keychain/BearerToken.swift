//
//  Password.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import Foundation

// Keys for KeyChain to save bearer token
let account = "su.brf.apps.AuthOnboardingSUI"

struct BearerToken: Codable
{
    let bearerToken: String
}
