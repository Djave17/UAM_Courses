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
        stackViewButtona.layer.borderWidth = 1
        stackViewButtona.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        stackViewButtona.layer.cornerRadius = 20
        setupUI()
        setNameAndEmail()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    //MARK: - Navegation
    @IBAction func btnLanguage(_ sender: Any) {
        let navLanguage = LanguagesViewController()
        navigationController?.pushViewController(navLanguage, animated: true)
    }
    
    @IBAction func btnChangePasswrod(_ sender: Any) {
        let nav = PasswordViewController()
        navigationController?.pushViewController(nav, animated: true)
    }
  
    @IBAction func btnContact(_ sender: Any) {
        let navContact = ContactViewController()
        navigationController?.pushViewController(navContact, animated: true)
    }
    
    @IBAction func tappedOnLogOut(_ sender: Any) {
        
        showCustomAlert(
            title: "Cerrar Sesión",
            message: "¿Estás seguro de cerrar sesión?",
            iconSystemName: "rectangle.portrait.and.arrow.right.fill",
            iconTintColor: .systemTeal,
            confirmTitle: "OK",
            confirmColor: .systemTeal,
            cancelTitle: "Cancelar",
            cancelColor: .systemTeal
        ) {
            // Aquí la lógica de cierre de sesión:
            self.apiClient.deleteToken()
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
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
