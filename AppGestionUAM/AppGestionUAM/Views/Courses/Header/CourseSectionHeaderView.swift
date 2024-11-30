//
//  CourseSectionHeaderView.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 16/11/24.
//

import UIKit

class CourseSectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = UIColor.darkGray
    }
}
