//
//  ArrowV.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI

struct ArrowV: View {
    let curSlideIndex : Int

    var body: some View {
        Group {
            if self.curSlideIndex == OnbordingM.onbordingData.count - 1 {
                HStack {
                    Text("Done")
                        .font(.system(size: 27, weight: .medium, design: .rounded))
                        .foregroundColor(Color(.systemBackground))
                }
                .frame(width: 120, height: 50)
                .background(Color(.label))
                .cornerRadius(25)
            } else {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable()
                    .foregroundColor(Color(.label))
                    .scaledToFit()
                    .frame(width: 50)
            }
        }
    }
}
