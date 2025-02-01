//
//  ContactViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 11/1/25.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var btnSend: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Custom Button
        btnSend.layer.cornerRadius = 10
    }
}
