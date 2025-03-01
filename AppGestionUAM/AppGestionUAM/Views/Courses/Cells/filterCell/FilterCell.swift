//
//  FilterCell.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 13/1/25.

import UIKit
class FilterCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .label
        return iv
    }()
    
    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            containerView.backgroundColor = isSelected ? .systemBlue : .systemGray6
            titleLabel.textColor = isSelected ? .white : .label
            iconImageView.tintColor = isSelected ? .white : .label
        }
    }
    
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
        [containerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [iconImageView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    // MARK: - Configuration
    func configure(with filter: String) {
        titleLabel.text = filter
        // Configurar el icono según el filtro
        switch filter {
        case "Derecho":
            iconImageView.image = UIImage(systemName: "building.columns")
        case "Inteligencia Artificial":
            iconImageView.image = UIImage(systemName: "brain")
        case "Idiomas":
            iconImageView.image = UIImage(systemName: "globe")
        case "Salud":
            iconImageView.image = UIImage(systemName: "heart")
        case "Publicidad":
            iconImageView.image = UIImage(systemName: "megaphone")
        case "Tecnología":
            iconImageView.image = UIImage(systemName: "laptopcomputer")
        default:
            iconImageView.image = UIImage(systemName: "book")
        }
    }
}
