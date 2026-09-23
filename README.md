# Convo - Campus Discussion Platform 🚀

Convo is a Flutter-based social discussion app designed specifically for college campuses (e.g., AKGEC). It provides a secure, real-time platform for students to ask questions, share updates, and connect over trending campus topics, club events, and academic resources.

## ✨ Key Features

*   **Secure Authentication:** Email/Password and Google Sign-In with mandatory Email Verification for campus security.
*   **Persistent Sessions:** Seamless auto-login experience powered by `SharedPreferences` (no plaintext data stored).
*   **Real-Time Discussion Feed:** Powered by **Cloud Firestore**. Create posts, select tags, and see live updates.
*   **Stateful Interactions:** Reddit-style dynamic feed with heart/like counters and comment tracking.
*   **Rich UI/UX:** 
    *   Search-integrated App Bar.
    *   Hamburger menu (Drawer) with **Dark/Light Mode** toggle.
    *   Dynamic, colorful user avatars and topic tags.
    *   Placeholder for image attachments in posts.
*   **Multi-Tab Navigation:** Dedicated screens for Feed, Explore (Trending tags & Clubs), and User Profile.

## 🛠 Tech Stack & Architecture

*   **Framework:** Flutter (Material 3 Design)
*   **Backend:** Firebase Authentication, Cloud Firestore
*   **State Management:** `Provider` (`ChangeNotifier`, `context.watch`, `context.read`)
*   **Local Storage:** `shared_preferences` (for session metadata routing)
*   **Architecture:** **MVVM (Model-View-ViewModel)**
    *   **Model/Data:** `AuthService`, `DiscussionService`, `LocalSessionService` (Handles raw API/DB calls).
    *   **ViewModel:** `AuthViewModel` (Handles business logic, loading states, and error handling).
    *   **View:** `FeedScreen`, `AuthWrapper`, `MainNavigationScreen` (Handles UI rendering and user inputs).

## 🚀 Getting Started

### Prerequisites
*   Flutter SDK (Latest stable version)
*   A Firebase Project with **Authentication** (Email & Google) and **Cloud Firestore** enabled.

### Setup Instructions

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/yourusername/convo.git](https://github.com/yourusername/convo.git)
    cd convo
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Firebase Configuration:**
    *   Register your app in the Firebase Console.
    *   Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and place them in their respective directories.
    *   Ensure Firestore Rules are set to allow read/write access during testing:
        ```text
        rules_version = '2';
        service cloud.firestore {
          match /databases/{database}/documents {
            match /{document=**} {
              allow read, write: if true; // Update for production!
            }
          }
        }
        ```

4.  **Run the app:**
    ```bash
    flutter run
    ```