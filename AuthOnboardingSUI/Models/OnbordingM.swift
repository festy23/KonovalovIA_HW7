//
//  OnbordingM.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import Foundation

struct OnbordingM: Identifiable {
    var id: Int
    var image: String
    var heading: String
    var text: String
}

extension OnbordingM {
    static var onbordingData: [OnbordingM] = [
        OnbordingM(id: 0, image: "welcome", heading: "Welcome", text: "Welcome to myRegisterApp!!"),
        OnbordingM(id: 1, image: "welcome1", heading: "Discover", text: "You can login right now!!"),
        OnbordingM(id: 2, image: "welcome2", heading: "Get Started", text: "Lets see other users too in the app!!"),
    ]
}
