////
////  CourseListViewController.swift
////  AppGestionUAM
////
////  Created by David Sanchez on 16/11/24.
////
//import UIKit
//import Combine
//
//class CourseListViewController: UIViewController {
//    
//    // Elementos de la vista
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Cursos"
//        label.font = UIFont.boldSystemFont(ofSize: 28)
//        label.textColor = UIColor(named: "UAMBlue") ?? UIColor.systemBlue
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Descubre nuevos cursos y aprende habilidades nuevas o certifica tus conocimientos."
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.textColor = .darkGray
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let searchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "Busca un curso..."
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        return searchBar
//    }()
//    
//    private let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 120) // Ajustar altura para la celda
//        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
//        layout.minimumLineSpacing = 16
//        layout.minimumInteritemSpacing = 0
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.backgroundColor = .white
//        return collectionView
//    }()
//    
//    // ViewModel y Combine
//    private let viewModel = CourseListViewModel()
//    private var dataSource: UICollectionViewDiffableDataSource<Int, CourseModel>!
//    private var cancellables = Set<AnyCancellable>()
//    
//    // MARK: - Ciclo de vida
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//        setupCollectionView()
//        setupDataSource()
//        bindViewModel()
//        viewModel.fetchCourses()
//    }
//    
//    // MARK: - Configuración de la UI
//    private func setupUI() {
//        navigationItem.hidesBackButton = true
//
//        view.addSubview(titleLabel)
//        view.addSubview(descriptionLabel)
//        view.addSubview(searchBar)
//        view.addSubview(collectionView)
//        
//        NSLayoutConstraint.activate([
//            // Constraints para el título
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            
//            // Constraints para la descripción
//            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            
//            // Constraints para la barra de búsqueda
//            searchBar.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            
//            // Constraints para la colección
//            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    // MARK: - Configuración del CollectionView
//    private func setupCollectionView() {
//        collectionView.register(CourseCollectionViewCell.self, forCellWithReuseIdentifier: "CourseCell")
//        collectionView.delegate = self
//    }
//    
//    private func setupDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<Int, CourseModel>(collectionView: collectionView) { collectionView, indexPath, course in
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCell", for: indexPath) as? CourseCollectionViewCell else {
//                fatalError("Cannot dequeue CourseCollectionViewCell")
//            }
//            cell.configure(with: course)
//            return cell
//        }
//    }
//    
//    // MARK: - Bind ViewModel
//    private func bindViewModel() {
//        viewModel.$courses
//            .sink { [weak self] courses in
//                self?.applySnapshot(with: courses)
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func applySnapshot(with courses: [CourseModel]) {
//        var snapshot = NSDiffableDataSourceSnapshot<Int, CourseModel>()
//        snapshot.appendSections([0]) // Una única sección
//        snapshot.appendItems(courses)
//        dataSource.apply(snapshot, animatingDifferences: true)
//    }
//}
//
//// MARK: - UISearchBarDelegate
//extension CourseListViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        viewModel.fetchCourses(query: searchText)
//    }
//}
//
//// MARK: - UICollectionViewDelegate
//extension CourseListViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let course = dataSource.itemIdentifier(for: indexPath) else { return }
//        print("Selected course: \(course.name)")
//    }
//}
