//
//  LoginViewController.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 31/10/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    //MARK: OUTLETS
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    //View
    @IBOutlet var viewH: UIView!
    @IBOutlet weak var bodyView: UIView!

    //Botones
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

       
    }
    
    //MARK: Tap On Log in
    
    @IBAction func tapOnLogin(_ sender: Any) {
        
        let courseListViewController = CourseListViewController()
        navigationController?.pushViewController(courseListViewController, animated: true)
    }
    
    
    //MARK: Tap On Register
    @IBAction func tapOnRegister(_ sender: Any) {

        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)

    }
    

    

}
