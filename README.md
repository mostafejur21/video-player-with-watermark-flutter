# 🎥 Flutter Video Player with Bouncing Watermark

A beautiful and customizable Flutter video player widget featuring an animated bouncing watermark overlay with full-screen support.

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

</div>

## ✨ Features

- 🎯 **Animated Bouncing Watermark** - Dynamic watermark that bounces around the video
- 📱 **Full-Screen Support** - Seamless transition to landscape full-screen mode
- 🎮 **Custom Video Controls** - Play/pause, progress bar, volume control, and fullscreen toggle
- 📐 **Responsive Design** - Adapts to different screen sizes using flutter_screenutil
- 🌐 **HLS Streaming** - Support for HTTP Live Streaming (HLS) video formats
- 🎨 **Modern UI** - Clean, Material Design 3 interface with smooth animations
- 🔄 **Auto-Rotation** - Automatic orientation handling for fullscreen mode

## 📸 Screenshots

| Portrait Mode | Fullscreen Mode | Video Controls |
|---------------|-----------------|----------------|
| *Add screenshot* | *Add screenshot* | *Add screenshot* |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- iOS Simulator / Android Emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/mostafejur21/video-player-with-watermark-flutter.git
   cd video-player-with-watermark-flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  video_player: ^2.8.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## 🏗️ Project Structure

```
lib/
├── main.dart                          # App entry point
├── data/
│   └── repositories/
│       └── video_repository_impl.dart # Video data repository
└── presentation/
    ├── screens/
    │   └── video_player_screen.dart   # Main screen
    └── widgets/
        ├── watermarked_video_player.dart     # Main video player widget
        ├── video_player_widget.dart          # Core video player
        ├── full_screen_video_player.dart     # Fullscreen implementation
        ├── custom_video_controls.dart        # Video control buttons
        ├── video_progress_bar.dart           # Progress bar slider
        ├── better_overlay.dart               # Bouncing watermark overlay
        ├── play_pause_button.dart           # Play/pause button
        ├── control_button.dart              # Generic control button
        └── video_watermark_overlay.dart     # Static watermark overlay
```

## 🎯 Key Components

### WatermarkedVideoPlayer
The main widget that wraps the video player with watermark functionality.

```dart
const WatermarkedVideoPlayer()
```

### BouncingOverlay
Creates an animated watermark that bounces around the video boundaries.

```dart
BouncingOverlay(
  playerWidth: 400.0,
  playerHeight: 300.0,
  offsetX: 0.0,
  offsetY: 0.0,
)
```

### CustomVideoControls
Provides comprehensive video playback controls.

```dart
CustomVideoControls(
  controller: videoPlayerController,
  onFullScreen: () => enterFullScreen(),
  showFullScreenButton: true,
  isFullScreen: false,
  iconSize: 16.0,
  fontSize: 10.0,
)
```

## 🔧 Configuration

### Customizing the Watermark

Edit `/lib/presentation/widgets/better_overlay.dart`:

```dart
// Change watermark text
displayText = "YOUR WATERMARK";

// Adjust animation speed
xSpeed = 2.0; // Horizontal speed
ySpeed = 1.5; // Vertical speed

// Modify appearance
TextStyle(
  color: Colors.white.withValues(alpha: 0.3),
  fontSize: 12,
  fontWeight: FontWeight.bold,
)
```

### Adding Your Video URL

Update the video URL in `/lib/presentation/widgets/watermarked_video_player.dart`:

```dart
const VideoPlayerWidget(
  videoUrl: 'YOUR_VIDEO_URL_HERE',
)
```

### Responsive Design

The app uses `flutter_screenutil` for responsive design. Adjust the design size in `main.dart`:

```dart
ScreenUtilInit(
  designSize: const Size(375, 812), // iPhone 12 Pro size
  // ... rest of configuration
)
```

## 📱 Supported Platforms

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12.0+)
- ⚠️ **Web** (Limited video format support)
- ❌ **Desktop** (Not tested)

## 🎥 Supported Video Formats

- **HLS** (.m3u8) - ✅ Recommended
- **MP4** (.mp4) - ✅ Supported
- **DASH** - ✅ Android only
- **Local Assets** - ✅ Supported

## 🐛 Troubleshooting

### Common Issues

**Video not playing:**
- Check internet connection
- Verify video URL is accessible
- Ensure video format is supported

**Fullscreen orientation issues:**
- Check device auto-rotation settings
- Restart the app if orientation gets stuck

**Watermark not bouncing:**
- Ensure video player size is properly calculated
- Check console for size calculation logs

### Debug Mode

Enable debug prints by checking the console output. Look for:
- `VideoPlayer initialized: [URL]`
- `BouncingOverlay animation started`
- `Updated playerSize: Size(width, height)`

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines

- Follow [Flutter style guide](https://dart.dev/guides/language/effective-dart/style)
- Add tests for new features
- Update documentation for API changes
- Ensure code passes `flutter analyze`

## 📋 Roadmap

- [ ] Multiple watermark support
- [ ] Watermark opacity animation
- [ ] Video quality selector
- [ ] Playback speed controls
- [ ] Subtitle support
- [ ] Picture-in-picture mode
- [ ] Video filters and effects

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [video_player](https://pub.dev/packages/video_player) - Flutter's official video player plugin
- [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) - Screen adaptation solution
- [Material Design 3](https://m3.material.io/) - Design system and components

## 📞 Support

If you found this project helpful, please give it a ⭐️!

For questions and support:
- 📧 Email: your.email@example.com
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/flutter-video-watermark/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/yourusername/flutter-video-watermark/discussions)

---

<div align="center">
Made with ❤️ and Flutter
</div>
