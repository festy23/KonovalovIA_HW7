//
//  OnboardingS.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI

struct OnboardingS: View {
    var onbordingData: [OnbordingM]
    var doneFunction: () -> ()
    
    @State private var slideGesture: CGSize = .zero
    @State private var curSlideIndex = 0
    @State private var animateContent = false
    private let distance: CGFloat = UIScreen.main.bounds.size.width
    
    private var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        ZStack {
            gradient
                .ignoresSafeArea()
            
            ZStack(alignment: .center) {
                ForEach(0..<onbordingData.count, id: \.self) { i in
                    OnboardingStepV(data: onbordingData[i])
                        .offset(x: CGFloat(i) * distance)
                        .offset(x: slideGesture.width - CGFloat(curSlideIndex) * distance)
                        .gesture(dragGesture)
                        .transition(
                            .asymmetric(
                                insertion: .offset(x: distance),
                                removal: .offset(x: -distance)
                            )
                            .animation(.easeInOut(duration: 0.3)))
                }
            }
            
            VStack {
                Spacer()
                
                HStack {
                    HStack(spacing: 8) {
                        ForEach(0..<onbordingData.count, id: \.self) { index in
                            Capsule()
                                .frame(width: index == curSlideIndex ? 30 : 15, height: 4)
                                .foregroundColor(index == curSlideIndex ? .white : .white.opacity(0.5))
                                .animation(.easeInOut(duration: 0.25), value: curSlideIndex)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: nextButton) {
                        Text(curSlideIndex == onbordingData.count - 1 ? "Get Started" : "Next")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(PressableButtonStyle())
                }
                .padding(25)
            }
        }
        .opacity(animateContent ? 1 : 0)
        .animation(.easeOut(duration: 0.4), value: animateContent)
        .onAppear { animateContent = true }
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                slideGesture = value.translation
            }
            .onEnded { value in
                handleDragEnd(value: value)
            }
    }
    
    private func nextButton() {
        if curSlideIndex == onbordingData.count - 1 {
            doneFunction()
            return
        }
        withAnimation(.easeInOut(duration: 0.3)) {
            curSlideIndex = min(curSlideIndex + 1, onbordingData.count - 1)
        }
    }
    
    private func handleDragEnd(value: DragGesture.Value) {
        if value.translation.width < -50 && curSlideIndex < onbordingData.count - 1 {
            withAnimation(.easeInOut(duration: 0.25)) {
                curSlideIndex += 1
            }
        } else if value.translation.width > 50 && curSlideIndex > 0 {
            withAnimation(.easeInOut(duration: 0.25)) {
                curSlideIndex -= 1
            }
        }
        slideGesture = .zero
    }
}
