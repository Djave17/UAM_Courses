//
//  CourseListViewController.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 13/1/25.
//

import UIKit

enum Section {
    case main
}


class CourseListViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, CourseModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CourseModel>
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var coursesCollectionView: UICollectionView!
    
    @IBOutlet weak var stackViewButtons: UIStackView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var addCourse: UIButton!
    
    // MARK: - Properties
    private let viewModel = CourseListViewModel()
    private lazy var dataSource: DataSource = makeDataSource()
    var filteredCourses: [CourseModel] = []
    private var snapshot = Snapshot()
    private let filters = ["Derecho", "Inteligencia Artificial", "Idiomas", "Salud", "Publicidad", "Tecnología"]
    private var selectedFilterIndex: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionViews()
        setupBindings()
        viewModel.fetchCourses()
        gestosKeyboard()
        setupLongPressGesture()
        
        
    }
    
    //Cargar los cursos si se navega hacia atras:
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchCourses()
    }
    
    func gestosKeyboard(){
        //Gesto para quitar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - UI
    func setupUI() {
        // Setup SearchBar
        searchBar.delegate = self
        searchBar.tintColor = .black
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = UIColor.black
        }
        
        
        
        
        // Setup StackView
        stackViewButtons.layer.cornerRadius = 25
        stackViewButtons.clipsToBounds = true
        stackViewButtons.layer.shadowColor = UIColor.black.cgColor
        stackViewButtons.layer.shadowOffset = CGSize(width: 0, height: 2)
        stackViewButtons.layer.shadowRadius = 4
        stackViewButtons.layer.shadowOpacity = 0.1
        
        navigationItem.hidesBackButton = true
        
        
    }
    
    func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.4
        longPressGesture.delegate = self
        coursesCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        print("Tiempo de presión: \(gesture.state.rawValue)") // Depuración
        
        guard gesture.state == .began else { return }
        let point = gesture.location(in: coursesCollectionView)
        guard let indexPath = coursesCollectionView.indexPathForItem(at: point), gesture.state == .began else { return }
        
        let selectedCourse = filteredCourses[indexPath.item]
        navigateToCourseDetail(with: selectedCourse.name, with: selectedCourse.id)
    }
    
    // MARK: - CollectionView Setup
    func setupCollectionViews() {
        // Courses CollectionView Setup
        coursesCollectionView.delegate = self
        //coursesCollectionView.dataSource = self
        coursesCollectionView.register(CourseCell.self, forCellWithReuseIdentifier: "CourseCell")
        
        // Filters CollectionView Setup
        //        filtersCollectionView.delegate = self
        //        //filtersCollectionView.dataSource = self
        //        filtersCollectionView.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        
        // Layout Setup
        setupCoursesLayout()
        //setupFiltersLayout()
    }
    
    private func setupCoursesLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        
        let width = (view.frame.width - 60) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.2)
        
        coursesCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    //    private func setupFiltersLayout() {
    //        let layout = UICollectionViewFlowLayout()
    //        layout.scrollDirection = .horizontal
    //        layout.minimumInteritemSpacing = 10
    //        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    //
    //        filtersCollectionView.setCollectionViewLayout(layout, animated: false)
    //    }
    
    // MARK: - Button Actions
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        // Animación de selección
        animateButtonSelection(sender)
        // Lógica para mostrar inicio
    }
    
    @IBAction func favoritesButtonTapped(_ sender: UIButton) {
        animateButtonSelection(sender)
        // Lógica para mostrar favoritos
    }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        animateButtonSelection(sender)
        // Lógica para mostrar perfil
        let createCourseViewController = CreateViewController()
        navigationController?.pushViewController(createCourseViewController, animated: true)
    }
    @IBAction func addCourseTapped(_ sender: UIButton) {
        animateButtonSelection(sender)
        // Lógica para mostrar perfil
        let createsCourseViewController = CreatesViewController()
        navigationController?.pushViewController(createsCourseViewController, animated: true)
    }
    
    private func animateButtonSelection(_ button: UIButton) {
        UIView.animate(withDuration: 0.1) {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = .identity
            }
        }
        
        
    }
    // MARK: - Diffable Data Source
    private func makeDataSource() -> DataSource {
        return DataSource(collectionView: coursesCollectionView) { collectionView, indexPath, course in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCell", for: indexPath) as? CourseCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: course)
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredCourses)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Bindings
    func setupBindings() {
        viewModel.onCoursesUpdated = { [weak self] in
            guard let self = self else { return }
            self.filteredCourses = self.viewModel.courses
            self.applySnapshot()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: errorMessage)
                print("fallo al cargar imagen")
            }
        }
    }
    
    
    
    // MARK: - Error Handling
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    func navigateToCourseDetail(with name: String, with id: String) {
        let detailsVC = DetailViewController()
        detailsVC.name = name
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    
}

//// MARK: - UICollectionViewDataSource
//extension CourseListViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == coursesCollectionView {
//            return filteredCourses.count
//        } else {
//            return filters.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == coursesCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCell", for: indexPath) as! CourseCell
//            let course = filteredCourses[indexPath.item]
//            cell.configure(with: course)
//            return cell
//        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
//            cell.configure(with: filters[indexPath.item])
//            return cell
//        }
//
//    }
//
//}

extension CourseListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let course = filteredCourses[indexPath.item]
        navigateToCourseDetail(with: course.name, with: course.id )
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    //        // Acción al mantener presionado
    //        let course = filteredCourses[indexPath.item]
    //        navigateToCourseDetail(with: course.name, with: course.id )
    //    }
}
// MARK: - UISearchBarDelegate
extension CourseListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredCourses = viewModel.courses
            applySnapshot()
            return
        }
        filteredCourses = viewModel.courses.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
        applySnapshot()
    }
}

extension CourseListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // Esto es para veridficar los gestos y su tiempo
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Da prioridad al gesto de presión prolongada
        if otherGestureRecognizer.view is UICollectionView {
            return true
        }
        return false
    }
}
