//
//  NavigationConfigurator.swift
//  Vanilla Dice
//
//  Created by John Reid on 29/5/2023.
//

import SwiftUI

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        let uiViewController = UIViewController()
        DispatchQueue.main.async {
            if let nc = uiViewController.navigationController {
                self.configure(nc)
            }
        }
        
        return uiViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}
