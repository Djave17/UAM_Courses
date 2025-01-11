////
////  CourseCollectionViewCell.swift
////  AppGestionUAM
////
////  Created by David Sanchez on 16/11/24.
////
//import UIKit
//
//class CourseCollectionViewCell: UICollectionViewCell {
//    
//    // Elementos visuales
//    private let courseImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.layer.cornerRadius = 8
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFill
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    private let courseNameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.textColor = UIColor(named: "UAMBlue") ?? UIColor.systemBlue
//        label.numberOfLines = 1
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let prerequisitesLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = .darkGray
//        label.numberOfLines = 1
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let scheduleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = .darkGray
//        label.numberOfLines = 1
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//        setupConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        courseImageView.image = nil
//        courseNameLabel.text = nil
//        prerequisitesLabel.text = nil
//        scheduleLabel.text = nil
//    }
//    
//    func configure(with course: CourseModel) {
//        courseNameLabel.text = course.name
//        prerequisitesLabel.text = "Requisitos: \(course.prerequisites)"
//        scheduleLabel.text = "Horario: \(course.schedule)"
//        
//        // Imagen Placeholder
//        courseImageView.image = UIImage(systemName: "photo")
//        
//        // Carga de imagen asíncrona
//        Task {
//            if let imageUrl = URL(string: course.imageUrl),
//               let imageData = try? Data(contentsOf: imageUrl) {
//                DispatchQueue.main.async {
//                    self.courseImageView.image = UIImage(data: imageData)
//                }
//            }
//        }
//    }
//    
//    private func setupViews() {
//        // Configuración de la vista
//        contentView.backgroundColor = .white
//        contentView.layer.cornerRadius = 8
//        contentView.layer.borderWidth = 0.5
//        contentView.layer.borderColor = UIColor.lightGray.cgColor
//        contentView.layer.shadowColor = UIColor.black.cgColor
//        contentView.layer.shadowOpacity = 0.1
//        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        contentView.layer.shadowRadius = 4
//        contentView.layer.masksToBounds = false
//        
//        // Añadir subviews
//        contentView.addSubview(courseImageView)
//        contentView.addSubview(courseNameLabel)
//        contentView.addSubview(prerequisitesLabel)
//        contentView.addSubview(scheduleLabel)
//    }
//    
//    private func setupConstraints() {
//        // Constraints para `courseImageView`
//        NSLayoutConstraint.activate([
//            courseImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            courseImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            courseImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
//            courseImageView.widthAnchor.constraint(equalToConstant: 80),
//            courseImageView.heightAnchor.constraint(equalToConstant: 80)
//        ])
//        
//        // Constraints para `courseNameLabel`
//        NSLayoutConstraint.activate([
//            courseNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            courseNameLabel.leadingAnchor.constraint(equalTo: courseImageView.trailingAnchor, constant: 8),
//            courseNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
//        ])
//        
//        // Constraints para `prerequisitesLabel`
//        NSLayoutConstraint.activate([
//            prerequisitesLabel.topAnchor.constraint(equalTo: courseNameLabel.bottomAnchor, constant: 4),
//            prerequisitesLabel.leadingAnchor.constraint(equalTo: courseImageView.trailingAnchor, constant: 8),
//            prerequisitesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
//        ])
//        
//        // Constraints para `scheduleLabel`
//        NSLayoutConstraint.activate([
//            scheduleLabel.topAnchor.constraint(equalTo: prerequisitesLabel.bottomAnchor, constant: 4),
//            scheduleLabel.leadingAnchor.constraint(equalTo: courseImageView.trailingAnchor, constant: 8),
//            scheduleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//            scheduleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
//        ])
//    }
//}
