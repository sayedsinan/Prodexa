    # 📋 Prodexa

    A **comprehensive Flutter application** for managing tasks with clean architecture, offline support, and a modern UI.
    This project is built as part of a **machine test** and demonstrates skills in state management, API integration, local storage, and clean code practices.

    ---

    ## 🚀 Features

    * **User Authentication**

    * Register and login using [ReqRes API](https://reqres.in).
    * Persist user sessions.

    * **Task Management**

    * Create, view, edit, and delete tasks using [JSONPlaceholder](https://jsonplaceholder.typicode.com/).
    * Task attributes include:

        * Title
        * Description
        * Due Date
        * Priority (High, Medium, Low)
        * Status (To-Do, In Progress, Done)
        * Assigned User (fetched via API)

    * **Offline Support**

    * Save tasks locally with **Hive**.
    * Sync tasks when online.

    * **User Information**

    * Fetch and display users from API for task assignment.

    * **Modern UI/UX**

    * Clean and responsive interface.
    * Custom animations and transitions.

    * **Error Handling**

    * Robust error messages for failed API calls and invalid form inputs.

    ---

    ## 🏗 Architecture

    This app follows a **Clean Architecture** approach with **GetX** for state management.

    ```
    lib/
    │── main.dart                # Entry point, setup GetX routes, dependencies
    │
    ├── core/                    # App-wide constants, themes, utils
    │   ├── constants.dart
    │   ├── app_routes.dart      # All named routes for navigation
    │   └── app_theme.dart
    │
    ├── data/                    # Data sources + repository implementations
    │   ├── api/
    │   │   ├── api_client.dart  # Base Dio/http client
    │   │   ├── auth_api.dart    # Login/Register API
    │   │   ├── task_api.dart    # Task CRUD API
    │   │   └── user_api.dart    # User list API
    │   │
    │   ├── local/
    │   │   ├── hive_service.dart # Offline storage
    │   │   └── db_helper.dart
    │   │
    │   ├── repository/
    │   │   ├── auth_repository_impl.dart
    │   │   ├── task_repository_impl.dart
    │   │   └── user_repository_impl.dart
    │
    ├── domain/                  # Business logic contracts + models
    │   ├── models/
    │   │   ├── user_model.dart
    │   │   ├── task_model.dart
    │   │   └── auth_model.dart
    │   │
    │   ├── repository/          # Abstract contracts (interfaces)
    │       ├── i_auth_repository.dart
    │       ├── i_task_repository.dart
    │       └── i_user_repository.dart
    │
    ├── presentation/            # UI + GetX controllers
    │   ├── auth/
    │   │   ├── login_screen.dart
    │   │   ├── register_screen.dart
    │   │   └── auth_controller.dart
    │   │
    │   ├── tasks/
    │   │   ├── task_list_screen.dart
    │   │   ├── task_detail_screen.dart
    │   │   ├── task_form_screen.dart   # Create/Edit
    │   │   └── task_controller.dart
    │   │
    │   ├── users/
    │   │   ├── user_dropdown.dart
    │   │   └── user_controller.dart
    │   │
    │   └── widgets/             # Reusable UI widgets
    │       
    │      
    │   
    │
    └── bindings/                # GetX bindings for DI
        ├── auth_binding.dart
        ├── task_binding.dart
        └── user_binding.dart

    ```

    * **Presentation Layer**: Flutter UI + GetX Controllers.
    * **Domain Layer**: Models (Task, User, Auth).
    * **Data Layer**: API services, repositories, local storage (Hive).

    ---

    ## 📦 Dependencies

    Key dependencies used in the project:

    * **State Management**: [get](https://pub.dev/packages/get)
    * **Networking**: [dio](https://pub.dev/packages/dio), [connectivity\_plus](https://pub.dev/packages/connectivity_plus)
    * **Local Storage**: [hive](https://pub.dev/packages/hive), [hive\_flutter](https://pub.dev/packages/hive_flutter), [shared\_preferences](https://pub.dev/packages/shared_preferences)
    * **UI/Animations**: [flutter\_animate](https://pub.dev/packages/flutter_animate), [lottie](https://pub.dev/packages/lottie)
    * **Utilities**: [logger](https://pub.dev/packages/logger), [equatable](https://pub.dev/packages/equatable)
    * **Validation**: [form\_builder\_validators](https://pub.dev/packages/form_builder_validators)

    ---

    ## ⚙️ Setup Instructions

    ### 1️⃣ Clone the repository

    ```bash
    git clone https://github.com/sayedsinan/Prodexa
    cd Prodexa
    ```

    ### 2️⃣ Install dependencies

    ```bash
    flutter pub get
    ```

    ### 3️⃣ Generate Hive adapters

    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

    ### 4️⃣ Run the app

    ```bash
    flutter run
    ```

    ---

    ## 🗄 Local Storage (Hive)

    * Hive is initialized in `HiveService`.
    * Tasks are cached locally in a box named `tasks`.
    * Offline-first approach → if API fails, app loads from Hive.

    ---

    ## 📡 APIs Used

    * **Authentication**

    * Register: `POST https://reqres.in/api/register`
    * Login: `POST https://reqres.in/api/login`

    * **Tasks**

    * Get: `GET https://jsonplaceholder.typicode.com/todos`
    * Create: `POST https://jsonplaceholder.typicode.com/todos`
    * Update: `PUT https://jsonplaceholder.typicode.com/todos/{id}`
    * Delete: `DELETE https://jsonplaceholder.typicode.com/todos/{id}`

    * **Users**

    * Get Users: `GET https://reqres.in/api/users`
    * Get User: `GET https://reqres.in/api/users/{id}`

    ---



    ## 📱 Screens Overview

    * **Login / Register**
    * **Task List**
    * **Task Form (create/edit)**
    * **User Dropdown Assignment**

    ---

    ## 🧑‍💻 Developer Notes

    * Built with **Flutter 3.10+** and **Dart 3**.
    * Code follows **Very Good Analysis** & **Flutter Lints**.
    * Clean code principles applied:

    * Meaningful naming
    * Single responsibility per class
    * Error handling
    * Modularity

    ---


    ---

    ## 📄 License

    This project is for **educational and machine test purposes**.
    Not intended for production use.

