//
//  Onboarding1ViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 13/1/25.
//

import UIKit

class Onboarding1ViewController: UIViewController {
    
    //Outlets Botones
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtvwOb1: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Design
        btnNext.layer.cornerRadius = 10
        
        //Desactivando interaccion con Text View
        //Scroll View
        txtvwOb1.isScrollEnabled = false
        //Edicion
        txtvwOb1.isEditable = false
        //Seleccion
        txtvwOb1.isSelectable = false
    }
    //Navegacion
    @IBAction func btnNav(_ sender: Any) {
        let onboarding2 = Onboarding2ViewController()
        onboarding2.navigationItem.hidesBackButton = true // Oculta el botón de "Back"
        navigationController?.pushViewController(onboarding2, animated: true)
    }
    
    
    @IBAction func saltarTapped(_ sender: Any) {
        
        let loginButton = LoginViewController()
        navigationController?.pushViewController(loginButton, animated: true)
        
    }
}

