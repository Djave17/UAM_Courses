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
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var stackViewButtons: UIStackView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var addCourse: UIButton!
    
    let apiClient = APIClient()
    
    // MARK: - Properties
    private let viewModel = CourseListViewModel()
    private lazy var dataSource: DataSource = makeDataSource()
    var filteredCourses: [CourseModel] = []
    private var snapshot = Snapshot()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionViews()
        setupBindings()
        //viewModel.fetchCourses()
        gestosKeyboard()
        setupLongPressGesture()
        loadCourses()
        //refreshFavorites()
        stackViewButtons.layer.borderWidth = 1  // Grosor del borde
        stackViewButtons.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor  // Color gris sutil con opacidad baja
        stackViewButtons.layer.cornerRadius = 20  // Bordes redondeados (opcional)
        // Obtener el nombre del usuario desde la API
        let name = apiClient.getUserName()

        // Crear el mensaje de bienvenida, con un valor por defecto si el nombre es nulo o vacío
        let welcomeMessage = "Bienvenid@ \(name?.isEmpty == false ? name ?? "Usuario" : "Usuario")"


        // Actualizar el texto del UILabel
        lblName.text = welcomeMessage
        
        
        navigationController?.navigationBar.shadowImage = UIImage()
           navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

        
    }
    
    //Cargar los cursos si se navega hacia atras:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySnapshot(filteredCourses)
        loadCourses()
    }
    
    
    // MARK: - Cargar cursos
    private func loadCourses() {
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
              textField.textColor = UIColor.systemTeal
              textField.backgroundColor = .white // Fondo blanco para el campo de texto
          }
          
          // Establecer fondo blanco para la barra de búsqueda
          searchBar.backgroundImage = UIImage() // Elimina la imagen de fondo
          searchBar.barTintColor = .white // Fondo blanco para la barra de búsqueda
          searchBar.isTranslucent = false // No translucidez, solo fondo blanco
          searchBar.layer.masksToBounds = true
        
        
        
        
        
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
        coursesCollectionView.delegate = self
        // La dataSource real la administra el DiffableDataSource
        coursesCollectionView.register(CourseCell.self, forCellWithReuseIdentifier: "CourseCell")
        
        setupCoursesLayout()
    }
    
    private func setupCoursesLayout() {
        let layout = UICollectionViewFlowLayout()
        // Márgenes superior, inferior, izquierdo y derecho
        let horizontalInset: CGFloat = 6
        layout.sectionInset = UIEdgeInsets(top: 10, left: horizontalInset, bottom: 10, right: horizontalInset)

        // Distancia entre filas y columnas
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        // Ancho disponible en el CollectionView
        let collectionWidth = coursesCollectionView.bounds.width
        
        // Espacio total ocupado por márgenes y la separación entre 2 celdas:
        //   margen izquierdo + margen derecho + separación entre columnas
        let totalSpacing = layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing
        
        // Cálculo de ancho para 2 celdas por fila
        let itemWidth = (collectionWidth - totalSpacing) / 2
        
        // Ajusta el alto a la proporción que desees (por ejemplo 1.2)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        
        // Configura el layout en el CollectionView
        coursesCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    

    // MARK: - Button Actions
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        // Animación de selección
        animateButtonSelection(sender)
        // Lógica para mostrar inicio
    }
    
    @IBAction func favoritesButtonTapped(_ sender: UIButton) {
        animateButtonSelection(sender)
        // Lógica para mostrar favoritos
        let favoriteVC = FavoriteCoursesViewController()
        navigationController?.pushViewController(favoriteVC, animated: true)
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
    
    // MARK: - Diffable DataSource
    private func makeDataSource() -> DataSource {
        return DataSource(collectionView: coursesCollectionView) { collectionView, indexPath, course in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCell", for: indexPath) as? CourseCell else {
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
    func navigateToCourseDetail(with name: String, with id: String) {
        let detailsVC = DetailViewController()
        detailsVC.name = name
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    
}


//MARK: -Delegates
extension CourseListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let course = filteredCourses[indexPath.item]
        navigateToCourseDetail(with: course.name, with: course.id )
    }

}
// MARK: - UISearchBarDelegate
extension CourseListViewController: UISearchBarDelegate {
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

extension CourseListViewController: CourseCellDelegate {
    func didToggleFavorite(course: CourseModel) {
        viewModel.toggleFavorite(for: course)
        
    }
}

