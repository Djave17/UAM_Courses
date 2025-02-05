//
//  EditProfileViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 4/2/25.
//

import UIKit

class EditProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Custom Button Back
        // Establecer el título en la barra de navegación
        self.title = "Editar Mi Perfil"
        
        // Configurar la apariencia de la barra de navegación
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Cambiar el color del título de la vista
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
        
        // Cambiar el color del botón Back y su flecha
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
        navigationController?.navigationBar.tintColor = .systemTeal
        
        // Aplicar la configuración a la barra de navegación
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

}
