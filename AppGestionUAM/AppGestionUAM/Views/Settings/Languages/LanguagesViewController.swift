//
//  LanguagesViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 11/1/25.
//

import UIKit

class LanguagesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Custom Button Back
        // Establecer el título en la barra de navegación
            self.title = "Idiomas"
        
        // Configurar la apariencia de la barra de navegación
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Cambiar el color del título de la vista
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
        
        // Cambiar el color del botón Back y su flecha
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
        navigationController?.navigationBar.tintColor = .systemTeal
        navigationController?.navigationBar.standardAppearance = { let appearance = UINavigationBarAppearance(); appearance.configureWithOpaqueBackground(); appearance.backgroundColor = .systemBackground; return appearance }()

        // Aplicar la configuración a la barra de navegación
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

}
