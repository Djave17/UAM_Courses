📱 AppGestionUAM
Aplicación iOS para gestión universitaria
Desarrollada en Swift | Proyecto Final iOS

📖 Descripción
AppGestionUAM es una aplicación iOS diseñada para facilitar la gestión académica de estudiantes y profesores de la Universidad Autónoma de Madrid (UAM). Incluye autenticación de usuarios, visualización de horarios, gestión de tareas y perfil personalizado.

🚀 Características Principales
Autenticación segura (estudiantes/profesores).

Horarios dinámicos con actualización en tiempo real.

Gestión de tareas (crear, completar, recordatorios).

Perfil personalizado con datos académicos.

Comunicación con API REST para sincronización de datos.

🏗️ Arquitectura: MVVM + Coordinators
El proyecto sigue una arquitectura modular con:

Models: Entidades de datos (Codable + CoreData).

ViewModels: Lógica de negocio y preparación de datos para la UI.

ViewControllers: Controladores de vista (UI) con Storyboards.

Coordinators: Navegación desacoplada entre pantallas.

Networking: Capa de red con URLSession (nativo).

📂 Estructura del Proyecto
Enlace al repositorio: GitHub - AppGestionUAM

plaintext
Copy
Proyecto_Final_iOS/
├── 📁 Models/               # Modelos de datos y persistencia
│   ├── User.swift          # 🧑💼 Modelo de usuario (Codable)
│   ├── Task.swift          # 📝 Modelo de tarea académica
│   └── CoreDataManager.swift # 🗃️ Gestor de Base de Datos local
│
├── 📁 ViewModels/           # Lógica de negocio
│   ├── LoginViewModel.swift # 🔐 Validación de credenciales
│   ├── ScheduleViewModel.swift # 🗓️ Gestión de horarios
│   └── TaskViewModel.swift # ✅ Lógica de tareas
│
├── 📁 ViewControllers/      # Controladores de UI
│   ├── LoginVC.swift       # 🖋️ Pantalla de inicio de sesión
│   ├── ScheduleVC.swift    # 📅 Vista de horario semanal
│   └── ProfileVC.swift     # 👤 Perfil del usuario
│
├── 📁 Views/                # Componentes UI reutilizables
│   ├── CustomTextField.swift # ✏️ Campo de texto personalizado
│   └── TaskCell.swift      # 📌 Celda para lista de tareas
│
├── 📁 Networking/           # Comunicación con API
│   ├── APIClient.swift     # 🌐 Cliente HTTP (URLSession)
│   └── Endpoints.swift     # 🔗 URLs de la API
│
├── 📁 Coordinators/         # Gestión de navegación
│   ├── AppCoordinator.swift # 🧭 Coordinador principal
│   └── AuthCoordinator.swift # 🔑 Flujo de autenticación
│
├── 📁 Resources/            # Assets e internacionalización
│   ├── Assets.xcassets     # 🖼️ Íconos/Imágenes
│   └── Localizable.strings # 🌍 Textos multi-idioma
│
└── 📁 Utils/                # Utilidades globales
    ├── Extensions.swift    # 🛠️ Extensiones (UIKit/Swift)
    └── KeyboardManager.swift # ⌨️ Gestión de teclado (IQKeyboardManager)
