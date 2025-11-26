#Cretaceous Dino Explorer — App Summary
```
Dino Run is an iOS game built using SwiftUI, SpriteKit, Core Data, and CoreML-style adaptive logic.

purpose
The app combines entertainment, allowing users to control a dinosaur in a 2D side-scrolling environment
Target Audience
Children aged 7–12, early learners, and students who enjoy dinosaurs, nature, and simple mobile games.
The game design and educational content are tailored to be easy to understand, visually appealing, and engaging.
```

# Key Features
## Playable 2D Dinosaur Game
```
Built using SpriteKit
Player controls a dinosaur that:
Runs
Jumps
Collects orbs
Avoids cactus hazards
Lives system (3 hits = game over)
Increasing challenge through adaptive difficulty
```

## Adaptive Difficulty (CoreML-style System)
```
Even without a full ML model, the app uses a CoreML-inspired algorithm that adjusts difficulty based on:
Score
Time survived
Orbs collected
Hazard hits taken
Remaining lives
Base difficulty selected by the user
This simulates machine-learning behavior and demonstrates knowledge of ML integration.
```

## Data Persistence (Core Data)
```
The app stores:
High scores
Date of play
Selected difficulty
This provides a persistent record that users can view later under the High Scores screen.
```

##Clean SwiftUI Navigation
```
The app includes several screens:
Home
Game
High Scores (Core Data)
Settings (select difficulty & options)
All connected using NavigationStack architecture.
```

#Image-Based Game Graphics
```
Replaces primitive shapes with real assets:
Dinosaur sprite
Orb item
Cactus hazard
Supports future expansion into animated sprites.
```

#Technologies Used
```
SwiftUI – UI screens, navigation, state management
SpriteKit – 2D gameplay and physics
Core Data – persistent saving of high scores
CoreML-style adaptive logic – simulated model for difficulty prediction
Combine – reactive updates to game state
Xcode Asset Catalog – for importing dinosaur/orb/cactus images
```

# Why This App Meets Assignment Requirements
At least 3 screens (Home, Game, Learn, Settings, High Scores)
Advanced UI + gameplay animations
Navigation & architecture via SwiftUI + NavigationStack
Data persistence via Core Data
Integration of emerging tech (CoreML-style logic system)
Polished visual assets & branding
clearly defined audience
Strong potential for extension (animations, ML model, sound, etc.)
