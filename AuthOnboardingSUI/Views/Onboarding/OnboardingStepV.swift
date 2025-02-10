//
//  OnboardingStepS.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI

struct OnboardingStepV: View {
    let data: OnbordingM
    
    var body: some View {
        VStack(spacing: 40) {
            Image(data.image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 20)
            
            VStack(spacing: 20) {
                Text(data.heading)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(data.text)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(6)
            }
        }
        .padding(.vertical, 40)
    }
}
