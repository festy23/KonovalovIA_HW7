//
//  ErrorV.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI

struct ErrorV: View
{
    @EnvironmentObject var vm: MainVM

    private let successNotificationShowTime: UInt64 = 1_500_000_000
    private let errorNotificationShowTime: UInt64 = 2_000_000_000
    
    var body: some View {
        VStack {
            switch vm.errorState {
            case .Success(let message):
                Text(message)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 15)
                    .background(.green)
                    .cornerRadius(15)
                    .task(hideNotification)
            case .Error(let message):
                Text(message)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 15)
                    .background(.red)
                    .cornerRadius(15)
                    .task(hideNotification)
            case .None:
                EmptyView()
            }
            Spacer()
        }.padding()
    }
    
    @Sendable private func hideNotification() async {
        switch vm.errorState {
        case .Error(_):
            try? await Task.sleep(nanoseconds: errorNotificationShowTime)
        case .Success(_):
            try? await Task.sleep(nanoseconds: successNotificationShowTime)
        case .None:
            return
        }
        withAnimation {
            vm.errorState = .None
        }
    }
}
