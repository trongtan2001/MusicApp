# Music App

A modern music streaming application built using Flutter.

## Features

- Play songs from a predefined library
- Search functionality to filter songs by title
- Bottom mini player to show the currently playing song with controls
- Dark mode and light mode support
- Tab navigation for Home, Discovery, Account, and Settings
- Share songs through social media platforms
- Download songs for offline playback
- Add favorite songs to your library
- Support for repeat and shuffle playback modes
- Login and user authentication with user profile management
- Responsive UI with Cupertino design for iOS users

## Getting Started

### Prerequisites

- Flutter 3.x or later
- Dart SDK
- Android Studio/VS Code (or any IDE of your choice)
- A physical or virtual device for testing (iOS or Android)

### Installation

1. Clone this repository:
    ```bash
    git clone https://github.com/trongtan2001/MusicApp.git
    ```
2. Navigate to the project directory:
    ```bash
    cd music_app
    ```
3. Install the dependencies:
    ```bash
    flutter pub get
    ```

### Running the App

1. Make sure you have a device or emulator connected.
2. Run the app:
    ```bash
    flutter run
    ```

### Folder Structure

lib/ 
├── models/ # Data models (Song, User) 
├── services/ # Logic for audio player and other services 
├── ui/ # All UI-related files 
│ ├── home/ # Home screen and related widgets 
│ ├── discovery/ # Discovery tab and song listings 
│ ├── account/ # Account tab with user information 
│ ├── settings/ # Settings tab with app preferences 
│ ├── widgets/ # Reusable widgets (ProgressBar, MediaControlButtons) 
├── main.dart # Main entry point of the app


### Key Components

1. **`AudioPlayerManager`:** Handles the audio playback, including play, pause, next, and previous functionalities using `just_audio` and `rxdart` packages.
2. **`HomeTabPage`:** Displays a list of songs and includes the search functionality to filter songs based on user input.
3. **`NowPlayingPage`:** Shows detailed information about the currently playing song with a rotating album cover, play/pause button, and seek bar.
4. **`CupertinoTabScaffold`:** Provides the tab-based navigation for Home, Discovery, Account, and Settings.
5. **`LoginPage`:** Allows users to login or sign up with an authentication system
6. **`AccountTab`:** Displays user profile information and recent activities.

### Dark Mode Support

The app supports dark and light themes by integrating the `Provider` package to handle theme switching dynamically.

### Search Functionality

The search bar appears when tapping the search icon on the Home screen. It filters songs by their title and displays the results in real-time.

### Mini Player

The mini player appears at the bottom of the screen when a song is playing. It shows the song's cover, title, and controls for pause/play.

### User Preferences Storage

The app uses shared_preferences to store user data locally on the device. This includes login information, favorite songs, and theme preferences. User data is retrieved and stored in a secure and efficient manner.

### Offline Mode

Downloaded songs can be played without an internet connection. The app provides an easy-to-use interface for managing offline music.

## Packages Used

- `just_audio`: Audio playback support.
- `rxdart`: For handling reactive streams.
- `provider`: State management for theme control and song state.
- `shared_preferences`: Persistent storage for user data and preferences.
- `cupertino_icons`: iOS-styled icons.
- `share`: Share functionality for sharing songs via social media.

## Performance Optimization

- `Caching`: Song details and preferences are cached locally to provide faster loading times. 
- `Memory Management`: Proper disposal of streams and controllers to optimize memory usage.

## Known Issues & Troubleshooting

- `Song Playback Delay`: There may be a slight delay in song playback due to network latency. Ensure a stable internet connection for optimal performance.
- `Dark Mode Not Saving`: If the app does not remember the selected theme, ensure that shared_preferences is correctly set up in your project.

## How to Contribute

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
