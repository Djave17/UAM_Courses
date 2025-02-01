//
//  ChangePassViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 11/1/25.
//

import UIKit

class ChangePassViewController: UIViewController {
    
    //Outlet TextView
    
    @IBOutlet weak var txtvwDesc: UITextView!
    
    //Outlet Button
    
    @IBOutlet weak var btnChange: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Desactivando interacción con Text View Descripcion
        txtvwDesc.isScrollEnabled = false
        txtvwDesc.isEditable = false
        txtvwDesc.isSelectable = false
        
        //Custom Button
        
        btnChange.layer.cornerRadius = 10
        
    }
}
