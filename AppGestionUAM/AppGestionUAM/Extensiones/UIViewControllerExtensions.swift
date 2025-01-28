//
//  UIViewControllerExtensions.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 26/1/25.
//

import UIKit

extension UIViewController {
    /// Oculta el botón de retroceso en la barra de navegación
    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
    }

    /// Oculta el botón de retroceso y agrega un botón personalizado
    func hideBackButton(withCustomButton title: String? = nil, action: Selector? = nil) {
        self.navigationItem.hidesBackButton = true
        
        if let title = title, let action = action {
            let customButton = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
            self.navigationItem.leftBarButtonItem = customButton
        }
    }
}
