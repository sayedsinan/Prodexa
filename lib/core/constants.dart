class AppConstants {
  // API URLs
  static const String baseAuthUrl = 'https://reqres.in/api';
  static const String baseTaskUrl = 'https://jsonplaceholder.typicode.com';
  
  // API Endpoints
  static const String loginEndpoint = '/login';
  static const String registerEndpoint = '/register';
  static const String usersEndpoint = '/users';
  static const String todosEndpoint = '/todos';


  
  // Local Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String tasksBoxKey = 'tasks_box';
  static const String usersBoxKey = 'users_box';
  
  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Priority levels
  static const List<String> priorityLevels = ['High', 'Medium', 'Low'];
  
  // Task status
  static const List<String> taskStatuses = ['To-Do', 'In Progress', 'Done'];
  
  static const String defaultEmail = 'eve.holt@reqres.in';  
  
  // Validation messages
  static const String requiredFieldError = 'This field is required';
  static const String invalidEmailError = 'Please enter a valid email';
  static const String passwordTooShortError = 'Password must be at least 6 characters';
  
  // Success messages
  static const String loginSuccessMessage = 'Login successful!';
  static const String registerSuccessMessage = 'Registration successful!';
  static const String taskCreatedMessage = 'Task created successfully!';
  static const String taskUpdatedMessage = 'Task updated successfully!';
  static const String taskDeletedMessage = 'Task deleted successfully!';
  
  // Error messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unknown error occurred.';
  static const String authenticationFailedMessage = 'Authentication failed. Please check your credentials.';
}