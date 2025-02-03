//
//  OnboardingS.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI

struct OnboardingS: View
{
    var onbordingData: [OnbordingM]
    var doneFunction: () -> ()
    
    @State var slideGesture: CGSize = CGSize.zero
    @State var curSlideIndex = 0
    var distance: CGFloat = UIScreen.main.bounds.size.width
    
    func nextButton() {
        if self.curSlideIndex == self.onbordingData.count - 1 {
            doneFunction()
            return
        }
        if self.curSlideIndex < self.onbordingData.count - 1 {
            withAnimation {
                self.curSlideIndex += 1
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            ZStack(alignment: .center) {
                ForEach(0..<onbordingData.count, id:\.self) { i in
                    OnboardingStepV(data: self.onbordingData[i])
                        .offset(x: CGFloat(i) * self.distance)
                        .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                        .gesture(DragGesture().onChanged({ value in
                            self.slideGesture = value.translation
                        })
                            .onEnded { value in
                                if self.slideGesture.width < -50 {
                                    if self.curSlideIndex < self.onbordingData.count - 1 {
                                        withAnimation {
                                            self.curSlideIndex += 1
                                        }
                                    }
                                }
                                if self.slideGesture.width > 50 {
                                    if self.curSlideIndex > 0 {
                                        withAnimation {
                                            self.curSlideIndex -= 1
                                        }
                                    }
                                    self.slideGesture = .zero
                                }
                            }
                        )
                }
            }
            VStack {
                Spacer()
                HStack() {
                    ProgressV(curSlideIndex: self.curSlideIndex)
                    Spacer()
                    Button {
                        self.nextButton()
                    } label: {
                        ArrowV(curSlideIndex: self.curSlideIndex)
                    }
                }
            }
            .padding(20)
        }
    }
}
