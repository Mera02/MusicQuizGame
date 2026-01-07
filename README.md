# 🎵 Music Quiz Game

A comprehensive terminal-based music quiz game built in Ruby, featuring 50 carefully curated songs from the Balkans spanning multiple genres and eras.

## 📋 Overview

Music Quiz Game is an interactive console application where players test their music knowledge by identifying songs, artists, albums, and release years based on various hints. The game supports both single-player and multiplayer modes with a sophisticated scoring system, lifelines, and persistent statistics tracking.

## ✨ Key Features

### 🎮 Multiple Quiz Modes
- **Guess the Song Title** - Identify songs by artist name
- **Guess the Artist** - Name the performer from song title
- **Year Guess** - Match songs to their release year
- **Album Guess** - Identify the album name
- **Mixed Mode** - Random combination of all modes

### 🎯 Difficulty Levels
- **Easy** (20s, 10 points) - Relaxed pace for casual players
- **Normal** (15s, 15 points) - Balanced challenge
- **Hard** (10s, 20 points) - Test your expertise under pressure

### 🎁 Lifeline System
- **Hints** - Get cultural clues about the song (-3 points)
- **Skip** - Pass on difficult questions without penalty
- **50/50** - Narrow down multiple choice options

### 📊 Persistent Statistics
- Global scoreboard tracking player performance
- Save/Load functionality to continue games later
- Comprehensive stats: high scores, streaks, accuracy

### 🎪 Dynamic Scoring
- Base points by difficulty
- Time bonus for quick answers
- Streak multipliers for consecutive correct answers
- Smart fuzzy matching for typo tolerance

## 🎸 Music Database

The game features **50 authentic Balkan songs** across five genres:

| Genre | Count | Artists |
|-------|-------|---------|
| **Ex-YU Rock** | 5 | Bijelo Dugme, Riblja Čorba, Idoli, Azra, Električni Orgazam |
| **Sevdah** | 5 | Himzo Polovina, Halid Bešlić, Safet Isović, Amira Medunjanin |
| **Pop Hits** | 10 | Zdravko Čolić, Oliver Dragojević, Toše Proeski, Dino Merlin |
| **Turbo Folk** | 10 | Lepa Brena, Ceca, Šaban Šaulić, Aca Lukas, Jelena Karleuša |
| **Modern** | 20 | Senidah, Voyage, Jala Brat & Buba Corelli, Edo Maajka |

*All hints are provided in local language (Serbian/Bosnian/Croatian) for authentic cultural flavor.*

## 🚀 Installation & Setup

### Prerequisites
- Ruby 3.0 or higher
- JSON gem (typically included with Ruby)

### Installation

```bash
# Clone the repository
git clone https://github.com/Mera02/MusicQuizGame.git
cd MusicQuizGame

# Install dependencies (if needed)
gem install json

# Run the game
ruby main.rb
```

## 🎮 How to Play

1. **Launch the game**: Run `ruby main.rb`
2. **Main Menu Options**:
   - Start New Game
   - Continue Game (resume saved session)
   - View Scoreboard
   - Exit

3. **Game Setup**:
   - Choose single-player or multiplayer mode
   - Select quiz mode (Song Title, Artist, Year, Album, or Mixed)
   - Pick difficulty level (Easy, Normal, Hard)
   - Set round format (fixed rounds or first-to-score)

4. **During Gameplay**:
   - Read the question and available hints
   - Type your answer (case-insensitive)
   - Use lifelines: Type `H` for hint, `S` to skip
   - Type `exit` anytime to return to menu

5. **Scoring**:
   - Earn points based on difficulty level
   - Build streaks for bonus points
   - Get time bonuses for quick answers
   - Compete on the global scoreboard!

## 🏗️ Project Structure

```
music_quiz/
├── main.rb              # Entry point
├── lib/
│   ├── menu.rb          # Main menu interface
│   ├── game.rb          # Game setup and flow
│   ├── quiz_engine.rb   # Core game logic
│   ├── question.rb      # Question handling
│   ├── player.rb        # Player state management
│   ├── scoring.rb       # Scoring calculations
│   ├── timer.rb         # Time management
│   ├── lifelines.rb     # Lifeline tracking
│   ├── scoreboard.rb    # Statistics persistence
│   └── save_load.rb     # Save/load system
└── data/
    ├── songs.json       # Song database (50 songs)
    ├── scoreboard.json  # Player statistics
    └── savegame.json    # Saved game state
```

## 🛠️ Technical Implementation

### Core Technologies
- **Ruby 3.x** - Primary programming language
- **JSON** - Data storage and serialization
- **ANSI Escape Codes** - Terminal colors and formatting

### Key Design Patterns
- **Object-Oriented Architecture** - Modular class-based design
- **Single Responsibility Principle** - Each class has one clear purpose
- **Data Persistence** - JSON-based save/load system
- **Fuzzy Matching** - Levenshtein distance algorithm for answer validation
- **MVC-like Structure** - Separation of data, logic, and presentation

### Notable Features
- **Answer Validation**: Accepts minor typos using fuzzy string matching (Levenshtein distance)
- **Turn-Based Multiplayer**: Clean player rotation with state tracking
- **Modular Extensibility**: Easy to add new modes, difficulties, or song genres
- **Graceful Error Handling**: Validates user input and handles edge cases
- **Cross-Platform**: Works on Windows, macOS, and Linux terminals

## 📈 Scoring System

| Difficulty | Base Points | Time Limit | Streak Bonus |
|------------|-------------|------------|--------------|
| Easy       | 10          | 20s        | +2 (3+ streak) |
| Normal     | 15          | 15s        | +2 (3+ streak) |
| Hard       | 20          | 10s        | +2 (3+ streak) |

**Additional Scoring:**
- Time Bonus: Up to +5 points for quick answers
- Hint Penalty: -3 points per hint used
- Skip: No penalty, preserves score

## 🎓 What We Learned

This project provided valuable hands-on experience with:

- **Ruby Programming**: Advanced syntax, file I/O, and array manipulation
- **Object-Oriented Design**: Creating maintainable, modular class architectures
- **Data Management**: JSON serialization, validation, and error handling
- **Algorithm Implementation**: Fuzzy string matching using Levenshtein distance
- **User Experience**: Terminal UI design, input validation, color coding
- **State Management**: Complex game state tracking across multiple players
- **Problem Solving**: Breaking down large problems into manageable components

## 🤝 Contributing

Contributions are welcome! Here are some ways you can help:

- Add more songs to the database
- Implement new quiz modes (e.g., Genre Guess, Lyrics Quiz)
- Create additional difficulty levels
- Add sound effects or ASCII art
- Improve answer validation algorithms
- Write unit tests

## 📝 License

This project was created as an educational assignment for the course **IT 305 / IT 3017 – Programming Languages**.

## 👥 Authors

- **Mera02** - Initial work and implementation

## 🙏 Acknowledgments

- Ruby community for excellent documentation
- GeeksforGeeks for algorithm references
- All the amazing Balkan artists featured in the game
- Course instructors for guidance and support

---

*Made with ❤️ for lovers of Balkan music and programming challenges*

## 🎯 Future Improvements

- [ ] Add audio playback of song snippets
- [ ] Implement online multiplayer mode
- [ ] Create mobile app version
- [ ] Add more regional music databases
- [ ] Implement difficulty-based AI opponents
- [ ] Add achievements and badges system
- [ ] Create web-based UI version
