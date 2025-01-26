//
//  Onboarding2ViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 13/1/25.
//

import UIKit

class Onboarding2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buttonContinueTapped(_ sender: Any) {
        let onBoarding2 = Onboarding3ViewController()
        navigationController?.pushViewController(onBoarding2, animated: true)
    }
    
    @IBAction func saltarTapped(_ sender: Any) {
        let loginButton = LoginViewController()
        navigationController?.pushViewController(loginButton, animated: true)
    }
}
