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
    git clone https://github.com/your_username/music_app.git
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

lib/ ├── models/ # Data models (Song, User) ├── services/ # Logic for audio player and other
services ├── ui/ # All UI-related files │ ├── home/ # Home screen and related widgets │ ├──
discovery/ # Discovery tab and song listings │ ├── account/ # Account tab with user information │
├── settings/ # Settings tab with app preferences │ ├── widgets/ # Reusable widgets (ProgressBar,
MediaControlButtons) ├── main.dart # Main entry point of the app


### Key Components

1. **`AudioPlayerManager`:** Handles the audio playback, including play, pause, next, and previous functionalities using `just_audio` and `rxdart` packages.
2. **`HomeTabPage`:** Displays a list of songs and includes the search functionality to filter songs based on user input.
3. **`NowPlayingPage`:** Shows detailed information about the currently playing song with a rotating album cover, play/pause button, and seek bar.
4. **`CupertinoTabScaffold`:** Provides the tab-based navigation for Home, Discovery, Account, and Settings.

### Dark Mode Support

The app supports dark and light themes by integrating the `Provider` package to handle theme switching dynamically.

### Search Functionality

The search bar appears when tapping the search icon on the Home screen. It filters songs by their title and displays the results in real-time.

### Mini Player

The mini player appears at the bottom of the screen when a song is playing. It shows the song's cover, title, and controls for pause/play.

## Packages Used

- `just_audio`: Audio playback support.
- `rxdart`: For handling reactive streams.
- `provider`: State management for theme control and song state.
- `cupertino_icons`: iOS-styled icons.
- `share`: Share functionality for sharing songs via social media.

## How to Contribute

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
