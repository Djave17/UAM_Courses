//
//  FavoriteCoursesViewController.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 1/2/25.
//

import UIKit



class FavoriteCoursesViewController: UIViewController, CourseCellDelegate {
    
    
    //MARK: - TYPEALIAS
    typealias DataSource = UICollectionViewDiffableDataSource<Section, CourseModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CourseModel>
    
    //MARK: - OUTLETS
    @IBOutlet weak var favoriteCoursesCollectionView: UICollectionView!
    @IBOutlet weak var searchFavoritesUIBar: UISearchBar!
    @IBOutlet weak var SettingsButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var stackViewButtonsFavorite: UIStackView!
    @IBOutlet weak var addCourseButton: UIButton!
    
    // MARK: - Properties
    private let viewModel = FavoriteCoursesViewModel()
    private lazy var dataSource: DataSource = makeDataSource()
    var filteredCourses: [CourseModel] = []
    private var snapshot = Snapshot()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupUI()
        setupCollectionViews()
        setupLongPressGesture()
        loadCourses()
        gestosKeyboard()
        
        
    }
    
    //Cargar los cursos si se navega hacia atras:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySnapshot(filteredCourses)
        loadCourses()
        setupBindings()
    }
    
    //MARK: - Gestos KeyBoard
    func gestosKeyboard(){
        //Gesto para quitar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Cargar cursos
    private func loadCourses() {
        viewModel.fetchFavoriteCourses()
    }
    
    //MARK: -Set UI
    func setupUI() {
        // Setup SearchBar
        searchFavoritesUIBar.delegate = self
        searchFavoritesUIBar.tintColor = .black
        if let textField = searchFavoritesUIBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = UIColor.black
        }
        
        // Setup StackView
        stackViewButtonsFavorite.layer.cornerRadius = 25
        stackViewButtonsFavorite.clipsToBounds = true
        stackViewButtonsFavorite.layer.shadowColor = UIColor.black.cgColor
        stackViewButtonsFavorite.layer.shadowOffset = CGSize(width: 0, height: 2)
        stackViewButtonsFavorite.layer.shadowRadius = 4
        stackViewButtonsFavorite.layer.shadowOpacity = 0.1
        
        navigationItem.hidesBackButton = true
        
        
    }
    
    //CollectionView Layers
    
    // MARK: - CollectionView Setup
    func setupCollectionViews() {
        favoriteCoursesCollectionView.delegate = self
        // La dataSource real la administra el DiffableDataSource
        favoriteCoursesCollectionView.register(FavoriteCoursesCollectionViewCell.self, forCellWithReuseIdentifier: "favoriteCell")
        
        setupCoursesLayout()
    }
    
    private func setupCoursesLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        
        let width = (view.frame.width - 60) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.2)
        
        favoriteCoursesCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    //MARK: - Set de Gestos
    func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.4
        longPressGesture.delegate = self
        favoriteCoursesCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        print("Tiempo de presión: \(gesture.state.rawValue)") // Depuración
        
        guard gesture.state == .began else { return }
        let point = gesture.location(in: favoriteCoursesCollectionView)
        guard let indexPath = favoriteCoursesCollectionView.indexPathForItem(at: point), gesture.state == .began else { return }
        
        let selectedCourse = filteredCourses[indexPath.item]
        navigateToCourseDetail(with: selectedCourse.name, with: selectedCourse.id)
    }
    
    // MARK: - Button Actions
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        // Animación de selección
        animateButtonSelection(sender)
        // Lógica para mostrar inicio
        let courseListViewController = CourseListViewController()
        navigationController?.pushViewController(courseListViewController, animated: true)
    }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        animateButtonSelection(sender)
        // Lógica para mostrar perfil
        let profileVC = SettingsViewController()
        navigationController?.pushViewController(profileVC, animated: true)
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
    
    func navigateToCourseDetail(with name: String, with id: String) {
        let detailsVC = DetailViewController()
        detailsVC.name = name
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    // MARK: - Diffable DataSource
    private func makeDataSource() -> DataSource {
        return DataSource(collectionView: favoriteCoursesCollectionView) { collectionView, indexPath, course in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as? FavoriteCoursesCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: course)
            cell.delegate = self  // Para toggleFavorite
            return cell
        }
    }
    
    private func applySnapshot(_ courses: [CourseModel]) {
        snapshot = NSDiffableDataSourceSnapshot<Section, CourseModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(courses)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Bindings
    func setupBindings() {
        viewModel.onCoursesUpdated = { [weak self] in
            guard let self = self else { return }
            // Cada vez que se actualicen los cursos en el viewModel,
            // sincronizamos el array local filteredCourses
            self.filteredCourses = self.viewModel.courses
            self.applySnapshot(self.filteredCourses)
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
    
}
//MARK: - Extensions
extension FavoriteCoursesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let course = filteredCourses[indexPath.item]
        navigateToCourseDetail(with: course.name, with: course.id )
    }

}
// MARK: - UISearchBarDelegate
extension FavoriteCoursesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            
            filteredCourses = viewModel.courses
            applySnapshot(filteredCourses)
            return
        }
        // Filtramos localmente
        filteredCourses = viewModel.courses.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
            || $0.description.localizedCaseInsensitiveContains(searchText)
        }
        applySnapshot(filteredCourses)
    }
}

extension FavoriteCoursesViewController: UIGestureRecognizerDelegate {
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

extension FavoriteCoursesViewController: FavoriteCellDelegate {
    func didToggleFavorite(course: CourseModel) {
        viewModel.toggleFavorite(for: course)
        viewModel.fetchFavoriteCourses()
        
    }
    
}

