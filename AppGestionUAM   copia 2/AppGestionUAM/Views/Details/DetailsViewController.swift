//
//  DetailsViewController.swift
//  AppGestionUAM
//
//  Created by Kristel Geraldine Villalta Porras on 14/1/25.
//

import UIKit

class DetailsViewController: UIViewController {

    //Referencia de Componentes
    
    @IBOutlet weak var btnContactanos: UIButton!
    @IBOutlet weak var btnInscribete: UIButton!
    @IBOutlet weak var btnPlanEstudios: UIButton!
    @IBOutlet weak var vwPlanEstudios: UIView!
    @IBOutlet weak var lblNameCourse: UILabel!
    @IBOutlet weak var btnMarkFavorite: UIButton!
    @IBOutlet weak var btnPlEstudios: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Bisel Botones
        btnPlEstudios.layer.cornerRadius = 20
        vwPlanEstudios.layer.cornerRadius = 20
        btnPlanEstudios.layer.cornerRadius = 20
        btnInscribete.layer.cornerRadius = 20
        btnContactanos.layer.cornerRadius = 20
        
        //Personalizacion de Boton Corazon
        // Configurar el botón como circular
        btnMarkFavorite.layer.cornerRadius = btnMarkFavorite.frame.size.width / 2.5
        btnMarkFavorite.backgroundColor = UIColor.systemTeal
        btnMarkFavorite.setTitleColor(.white, for: .normal)
        btnMarkFavorite.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
               
               // Sombra
        btnMarkFavorite.layer.shadowColor = UIColor.black.cgColor
        btnMarkFavorite.layer.shadowOpacity = 0.25
        btnMarkFavorite.layer.shadowOffset = CGSize(width: 2, height: 2)
        btnMarkFavorite.layer.shadowRadius = 4
        
        
        //Personalizacion de Parrafos en toda la interfaz
        // Configuracion de Lineas dependiendo de la categoria del label
        lblNameCourse.numberOfLines = 3
        
        
        //Justificacion de labels
        lblNameCourse.textAlignment = .justified
        
        
    }



}
