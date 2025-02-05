//
//  ContactViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 11/1/25.
//

import UIKit

class ContactViewController: UIViewController {

    //Outlets Text Views
    @IBOutlet weak var vwtxtDesc: UITextView!
    
    //Outlets Views
    @IBOutlet weak var vwSocialMedia: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customs View
        vwSocialMedia.layer.cornerRadius = 10
        
        //Configurando txtView
        // Desactivando interacción con Text View Title
        vwtxtDesc.isScrollEnabled = false
        vwtxtDesc.isEditable = false
        vwtxtDesc.isSelectable = false

        //Custom Button Back
        // Establecer el título en la barra de navegación
            self.title = "Contáctanos"
        
        
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

