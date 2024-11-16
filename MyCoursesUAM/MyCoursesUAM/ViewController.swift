//
//  ViewController.swift
//  MyCoursesUAM
//
//  Created by Kristel Geraldine Villalta Porras on 15/11/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var teacherbutton: UIButton!
    @IBOutlet weak var studentbutton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // IBAction para el botón teacherbutton
    @IBAction func teacherButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showLogInTeacher", sender: self)
    }
}
