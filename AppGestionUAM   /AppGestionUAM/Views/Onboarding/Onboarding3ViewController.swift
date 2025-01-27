//
//  Onboarding3ViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 13/1/25.
//

import UIKit

class Onboarding3ViewController: UIViewController {

    //Outlets
    @IBOutlet weak var btnSig: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackButton()
        //Borde Circular
        btnSig.layer.cornerRadius = 10
        
    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func tappedOnIniciarSesi(_ sender: Any) {
        let loginButton = LoginViewController()
        navigationController?.pushViewController(loginButton, animated: true)
        
    }
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        let loginButton = RegisterViewController()
        navigationController?.pushViewController(loginButton, animated: true)
    }
    
    @IBAction func saltarButtonTapped(_ sender: Any) {
        let loginButton = LoginViewController()
        navigationController?.pushViewController(loginButton, animated: true)
    }
}
