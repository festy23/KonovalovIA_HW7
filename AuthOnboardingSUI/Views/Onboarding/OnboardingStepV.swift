//
//  OnboardingStepS.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI
import SwiftUI

struct OnboardingStepV: View {
    let data: OnbordingM

    var body: some View {
        VStack(spacing: 20) {
            Image(data.image)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
            Text(data.heading)
                .font(.title)
                .bold()
            Text(data.text)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

struct OnboardingStepV_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStepV(data: OnbordingM(id: 0, image: "scr2", heading: "Welcome", text: "Welcome to our app!"))
    }
}

struct OnboardingView: View {
    @State private var currentPage = 0
    let onboardingData = OnbordingM.onbordingData  // Убедитесь, что массив не пустой

    var body: some View {
        VStack {
            if onboardingData.isEmpty {
                Text("No onboarding data available")
            } else {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        OnboardingStepV(data: onboardingData[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                Button(action: {
                    if currentPage < onboardingData.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        // Действие при завершении онбординга, например:
                        UserDefaults.standard.set(true, forKey: "onboardingDone")
                        // Перейти к экрану авторизации или главному экрану приложения.
                    }
                }) {
                    HStack {
                        Text(currentPage < onboardingData.count - 1 ? "Next" : "Get Started")
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .font(.title2)
                    .padding()
                }
            }
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
