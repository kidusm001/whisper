# Whisper - Exclusive Content Platform

A social content platform empowering creators to share exclusive content and build engaged communities. Built with Flutter and Firebase/Supabase backend.

![Whisper App Preview](docs/assets/app-preview.png) <!-- Add actual screenshot later -->

## Features ✨

- **Secure Authentication** 🔒  
  Email/password login with Firebase Auth
- **Rich Content Creation** 📝  
  Post text/images with publish control
- **Subscription System** 💰  
  Monetize content with subscriber relationships
- **Social Features** 👥  
  Follow creators, comment, explore feed
- **Cross-Platform** 📱  
  iOS/Android support from single codebase

## Tech Stack 🛠️

- **Frontend**: Flutter + Provider state management
- **Backend**: 
  - Firebase (Auth/Firestore)
  - Supabase Storage (for media)
- **Security**: Firestore Rules + AES encryption

## Getting Started 🚀

### Prerequisites
- Flutter SDK ≥3.0
- Firebase project
- Supabase account

### Installation

1. **Clone repo**
   ```bash
   git clone https://github.com/your-org/whisper.git
   cd whisper
   ```

2. **Configure services**
   - Add Firebase config files:
     - `android/app/google-services.json`
     - `ios/Runner/GoogleService-Info.plist`
   - Set Supabase credentials in `lib/main.dart`

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Firestore Index Setup** 🔍  
   Create composite index:
   ```
   authorId (Ascending)
   isDeleted (Ascending) 
   createdAt (Descending)
   ```

## Documentation 📚

Full documentation available at:  
[Whisper Documentation Guide](docs/documentation.md)

Includes:
- Architecture overview
- API references
- Deployment guide
- Roadmap
- Regulatory compliance details

## Contributing 🤝

We welcome contributions! Please see:  
[CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License 📄

MIT License - See [LICENSE](LICENSE) for details.

---

**Whisper Inc.** © 2025 - Building meaningful creator communities
