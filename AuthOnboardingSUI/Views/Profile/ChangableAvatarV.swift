//
//  ChangableAvatarV.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI
import PhotosUI

struct ChangableAvatarV: View
{
    @ObservedObject var vm: UserProfileM

    var body: some View {
        ProfileImageV(imageState: vm.imageState)
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
            .background {
                Circle().fill(
                    Color(.red))
            }
            .overlay(alignment: .center) {
                PhotosPicker(selection: $vm.imageSelection, matching: .images, photoLibrary: .shared()) {
                    Circle()
                        .opacity(0.1)
                }
                .buttonStyle(.borderless)
            }
    }
}
