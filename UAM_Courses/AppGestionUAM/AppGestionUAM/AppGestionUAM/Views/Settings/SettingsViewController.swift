//
//  SettingsViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 11/1/25.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stackViewButtona: UIStackView!
    let apiClient = APIClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackViewButtona.layer.borderWidth = 1  // Grosor del borde
        stackViewButtona.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor  // Color gris sutil con opacidad baja
        stackViewButtona.layer.cornerRadius = 20  // Bordes redondeados (opcional)

        
        setupUI()

        setNameAndEmail()
        //Log Out Configuracion con Alerta
    }

    //MARK: - Navegation
    
    @IBAction func btnLanguage(_ sender: Any) {
        let navLanguage = LanguagesViewController()
        navigationController?.pushViewController(navLanguage, animated: true)
    }
    
    @IBAction func btnChangePasswrod(_ sender: Any) {
        // En SettingsViewController
        let passVC = PassViewController()
        passVC.isFromLogin = false  // Establecer que venimos de Settings
        navigationController?.pushViewController(passVC, animated: true)
    }
  
    
    
    @IBAction func btnContact(_ sender: Any) {
        let navContact = ContactViewController()
        navigationController?.pushViewController(navContact, animated: true)
    }
    @IBAction func tappedOnLogOut(_ sender: Any) {
        
        let navLogin = LoginViewController()
        navigationController?.pushViewController(navLogin, animated: true)
        apiClient.deleteToken()
        
    }
    
    @IBAction func tappedOnHomeButton(_ sender: Any) {
        
        let courseListVC = CourseListViewController()
        navigationController?.pushViewController(courseListVC, animated: true)
    }
    
    @IBAction func tappedOnFavoriteButton(_ sender: Any) {
        let favoriteVC = FavoriteCoursesViewController()
        navigationController?.pushViewController(favoriteVC, animated: true)
    }
    
    
    //MARK: - UI
    func setupUI() {
        // Setup SearchBat
        
        // Setup StackView
        stackViewButtona.layer.cornerRadius = 25
        stackViewButtona.clipsToBounds = true
        stackViewButtona.layer.shadowColor = UIColor.black.cgColor
        stackViewButtona.layer.shadowOffset = CGSize(width: 0, height: 2)
        stackViewButtona.layer.shadowRadius = 4
        stackViewButtona.layer.shadowOpacity = 0.1
        
        navigationItem.hidesBackButton = true
        
        
    }
    
    
    func setNameAndEmail(){
        let name = apiClient.getUserName()
        let email = apiClient.getUserEmail()
        nameLabel.text = name ?? "Usuario desconocido"
        emailLabel.text = email ?? "Email no disponible"
    }
    
}
