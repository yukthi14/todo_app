# todo_app
 This Flutter application is a simple task management app with user authentication and CRUD operations on tasks, leveraging Firebase Authentication and Firestore. Users can register, log in, and manage their tasks, which include setting deadlines and receiving notifications.

## Get Started
1. Firebase Setup
   Go to the Firebase Console.
   Create a new project or use an existing project.
   Add an Android/iOS app to your Firebase project.
   Follow the instructions to download the google-services.json (for Android)and place them in the appropriate directories (android/app).
2. Configure Firebase in Flutter
   Add the dependencies to your pubspec.yaml file.
   Initialize Firebase in your main.dart file.
3.  Implement Authentication
    Create auth_service.dart to handle Firebase Authentication.
4. Implement Firestore CRUD Operations
   Create task_service.dart to handle Firestore operations.
   Create task_model.dart for the Task model.
5. Implement Notifications
   Create notification_service.dart to handle notifications.
6. Run the App
   Run flutter pub get to install dependencies.
   Start the app using flutter run.