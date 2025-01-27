//
//  Onboarding2ViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 13/1/25.
//

import UIKit

class Onboarding2ViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var btnSig: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    //Borde Circular
    btnSig.layer.cornerRadius = 10
    }
    
    @IBAction func buttonContinueTapped(_ sender: Any) {
        let onBoarding2 = Onboarding3ViewController()
        onBoarding2.navigationItem.hidesBackButton = true // Oculta el botón de "Back"
        navigationController?.pushViewController(onBoarding2, animated: true)
    }
    
    @IBAction func saltarTapped(_ sender: Any) {
        let loginButton = LoginViewController()
        navigationController?.pushViewController(loginButton, animated: true)
    }
}
