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
        OnbordingM(id: 0, image: "scr2", heading: "Welcome", text: "Welcome to our app!"),
        OnbordingM(id: 1, image: "scr1", heading: "Discover", text: "Very cool app!!!"),
        OnbordingM(id: 2, image: "scr3", heading: "Get Started", text: "Let’s get started!")
    ]
}
