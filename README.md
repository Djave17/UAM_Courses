## 📚 AppGestionUAM

Bienvenido a **AppGestionUAM**, una aplicación iOS desarrollada en Swift con arquitectura **MVVM** para la gestión de cursos universitarios. 🚀

---

## 📌 Índice

- [📖 Descripción](#-descripción)
- [📱 Interfaces de Usuario](#-interfaces-de-usuario)
- [📂 Estructura del Proyecto](#-estructura-del-proyecto)
- [🔧 Tecnologías Usadas](#-tecnologías-usadas)
- [📸 Recursos](#-recursos)
- [📜 Licencia](#-licencia)

---

## 📖 Descripción

**AppGestionUAM** permite a los estudiantes explorar cursos universitarios, obtener información detallada, marcar favoritos y gestionar su carga académica.

### 🎯 Funcionalidades principales:
✅ Autenticación de usuarios (Login, Registro)  
✅ Listado y búsqueda de cursos  
✅ Detalle de cada curso con horarios, requisitos y materiales  
✅ Gestión de favoritos  
✅ Creación y edición de cursos (para administradores)  
✅ Persistencia de datos con **UserDefaults**  
✅ Soporte multimedia (videos e imágenes)  


---

## 📱 Interfaces de Usuario

La aplicación UAMCourses para la Universidad Americana (UAM) de Nicaragua permitirá a los administradores gestionar de manera eficiente la creación, lectura, actualización y eliminación de cursos. La interfaz contará con pantallas intuitivas y fáciles de usar:

## Launcher/OnBoarding

<p align="center">
  <img src="Images/Onboarding.gif" alt="Mi Animación" width="300" heigth="400" />
</p>


---

## Register

<p align="center">
  <img src="Images/Register.gif" alt="Visualizacion de registro de usuario" width="300" heigth="400" />
</p>


---
## Login

<p align="center">
  <img src="Images/Login.gif" alt="Visualizacion de login de usuario" width="300" heigth="400" />
</p>


---

## Agreagar curso como favorito

<p align="center">
  <img src="Images/Favoritos.gif" alt="Creacion de curso" width="300" heigth="400" />
</p>


---

## Crear Curso

<p align="center">
  <img src="Images/Crear Curso .gif" alt="Creacion de curso" width="300" heigth="400" />
</p>


---

## Editar Curso

<p align="center">
  <img src="Images/Editar.gif" alt="Creacion de curso" width="300" heigth="400" />
</p>


---

## Editar Curso

<p align="center">
  <img src="Images/Eliminar.gif" alt="Creacion de curso" width="300" heigth="400" />
</p>


---
## 📂 Estructura del Proyecto

La aplicación sigue una estructura organizada basada en **MVVM**:

📁 [`AppGestionUAM`](https://github.com/Djave17/Proyecto_Final_iOS/tree/main/AppGestionUAM)  *(Carpeta raíz del código fuente)*

- 📂 [`ViewControllers`](https://github.com/Djave17/Proyecto_Final_iOS/tree/main/AppGestionUAM/AppGestionUAM/Views) → Controladores de UI y navegación.
- 📂 [`ViewModels`](https://github.com/Djave17/Proyecto_Final_iOS/tree/main/AppGestionUAM/AppGestionUAM/ViewModels) → Lógica de negocio y conexión entre UI y Modelos.
- 📂 [`Models`](https://github.com/Djave17/Proyecto_Final_iOS/tree/main/AppGestionUAM/AppGestionUAM/Models) → Definición de estructuras de datos (`Course`, `User`, etc.).
- 📂 [`Networking`](https://github.com/Djave17/Proyecto_Final_iOS/tree/main/AppGestionUAM/AppGestionUAM/Networking%20) → Comunicación con la API REST.
- 📂 [`Persistance`](https://github.com/Djave17/Proyecto_Final_iOS/tree/main/AppGestionUAM/AppGestionUAM/Persistance) → Gestión de favoritos con `UserDefaults`.
- 📂 [`Extensiones`](https://github.com/Djave17/Proyecto_Final_iOS/tree/main/AppGestionUAM/AppGestionUAM/Extensiones) → Métodos adicionales para mejorar `UIViewController`.
- 📂 [`Resources`](https://github.com/Djave17/Proyecto_Final_iOS/tree/main/AppGestionUAM/Resources) → Imágenes, sonidos (`agua.mp3`), y videos (`vd_Onb1.mov`, `vd_Onb2.mov`, `vd_Onb3.mov`, `vd_Onb4.mov`).
- 📂 [`Tests`](https://github.com/Djave17/Proyecto_Final_iOS/tree/main/AppGestionUAM/AppGestionUAMTests) → Pruebas unitarias y de UI.

---


## 🏗️ Estructura del Proyecto (Detallada)

```plaintext
UAMCourses/
├── AudioManager/           
│
├── Extensiones/           
│
├── Models/
│
├── Networking/           
│
├── Persistance/
│
├── Resources/              # Almacena todo los archivos en formato mov, mp3 y static
│   ├── Mulish              # Almacena todos los tipos de letra de la fuente Mulish        
│
├── ViewModels/              
│
├── Views/
│   ├── Courses             # Almacena el Home Page de los cursos 
│   ├── Create              # Almacena la Vista para añadir cursos
│   ├── DetailView          # Almacena la Vista Previa y Editor de Cursos
│   ├── Extra               # Almacena el controlador del CircularProgressBar
│   ├── FavoriteCourses     # Almacena el controlador y la vista de Mis Favoritos
│   ├── Filter              # Almacena la controlador y vista del filtro inicial de los cursos de interes del usuario
│   ├── Launcher            # Almacena el controlador y vista del Launcher
│   ├── Login               # Almacena el controlador y vista del Inicio de Sesion
│   ├── Onbording           # Almacena los Onboardings Iniciales de la Aplicacion
│   ├── Register            # Almacena el controlador y vista del Registro de Usuarios
│   ├── Settings            # Almacena los controladores y las vistas de Ajustes│
└── README.md                 # Documentación principal del proyecto

```
---

## 🔧 Tecnologías Usadas

- **Swift** 🚀
- **UIKit & Storyboards** 🎨
- **MVVM Architecture** 🏗️
- **URLSession** 🌐
- **IQKeyboardManager** 🎹 (Para mejorar la interacción con el teclado)
- **UserDefaults** 💾 (Persistencia de datos)

---
## 👥 Equipo de Desarrollo

- **David Sanchez** - Desarrollador, Líder del Proyecto 🚀
- **Kristel Villalta** - Desarrolladora FrontEnd / Diseñadora UI/UX 😊
- **Carlos** - Desarrollador

---

## 📸 Recursos

- 🔊 [`agua.mp3`](https://github.com/Djave17/Proyecto_Final_iOS/tree/main/AppGestionUAM/Resources) (Efecto de sonido)
- 🎥 [`vd_Onb1.mov`](https://github.com/Djave17/Proyecto_Final_iOS/blob/main/AppGestionUAM/AppGestionUAM/vd_Onb1.mov)
- 🎥 [`vd_Onb2.mov`](https://github.com/Djave17/Proyecto_Final_iOS/blob/main/AppGestionUAM/AppGestionUAM/vd_Onb2.mov))
- 🎥 [`vd_Onb3.mov`](https://github.com/Djave17/Proyecto_Final_iOS/blob/main/AppGestionUAM/AppGestionUAM/vd_Onb3.mov)

---

## 📜 Licencia

Este proyecto está licenciado bajo la **Licencia MIT**. Puedes ver los detalles en el siguiente enlace:

📄 [Licencia MIT](https://github.com/Djave17/Proyecto_Final_iOS/blob/main/LICENSE)

