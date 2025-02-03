//
//  SafariV.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI
import SafariServices

struct SafariV: UIViewControllerRepresentable
{
    typealias UIViewControllerType = SFSafariViewController
    let url: URL
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariV>) {
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariV>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
}
