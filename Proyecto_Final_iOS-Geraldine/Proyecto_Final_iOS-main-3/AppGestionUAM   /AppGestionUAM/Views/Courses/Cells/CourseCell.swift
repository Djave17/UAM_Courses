//
//  CourseListCollectionViewCell.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 13/1/25.
//
import UIKit

class CourseCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let scheduleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 2
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 6
        
        // Add subviews to contentView
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(scheduleLabel)
        contentView.addSubview(favoriteButton)
        
        // Ensure translatesAutoresizingMaskIntoConstraints is false for all views
        [imageView, titleLabel, scheduleLabel, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Add constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.50),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            
            scheduleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            scheduleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            scheduleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            scheduleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            favoriteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Configuration
    func configure(with course: CourseModel) {
        titleLabel.text = course.name
        // Imagen Placeholder
        imageView.image = UIImage(systemName: "photo")
        
        // Carga de imagen asíncrona con caché
        Task {
            if let image = await APIClient.shared.loadImage(url: course.imageUrl) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
                
            
            }
            //LoadImage
            
            //        if let imageUrl = URL(string: course.imageUrl) {
            //            DispatchQueue.global().async {
            //                if let data = try? Data(contentsOf: imageUrl), let image = UIImage(data: data) {
            //                    DispatchQueue.main.async {
            //                        self.imageView.image = image
            //                    }
            //                } else {
            //                    DispatchQueue.main.async {
            //                        self.imageView.image = UIImage(systemName: "photo")
            //                    }
            //                }
            //            }
            //        } else {
            //            imageView.image = UIImage(systemName: "photo")
            //        }
            scheduleLabel.text = course.schedule
            favoriteButton.setImage(UIImage(systemName: course.isFavorite ?? false ? "heart.fill" : "heart"), for: .normal)
        }
    }
}
