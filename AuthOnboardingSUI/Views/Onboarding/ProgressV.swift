//
//  ProgressV.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI

struct ProgressV: View
{
    let curSlideIndex : Int
    
    var body: some View {
        HStack {
            ForEach(0..<OnbordingM.onbordingData.count) { i in
                Circle()
                    .scaledToFit()
                    .frame(width: 10)
                    .foregroundColor(self.curSlideIndex >= i ? Color(.systemIndigo) : Color(.systemGray))
            }
        }
    }
}
