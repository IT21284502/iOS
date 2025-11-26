# Cretaceous Dino Explorer — App Summary

Dino Run is an iOS game built using SwiftUI, SpriteKit, Core Data, and an adaptive CoreML-style difficulty system.  
The app combines entertainment with light educational elements, allowing users to control a dinosaur in a side-scrolling 2D environment.

## Purpose
The goal of the app is to create a simple, engaging dinosaur-themed game that is easy to understand and fun to play.

## Target Audience
Designed for children aged 7–12, early learners, and students who enjoy dinosaurs, nature, and simple mobile games.  
Visuals and gameplay mechanics are intentionally kept clear, bright, and child-friendly.

---

# Key Features

## Playable 2D Dinosaur Game
Built using SpriteKit.  
Players control a dinosaur that can:
- Run  
- Jump  
- Collect orbs  
- Avoid cactus hazards  
- Survive with a 3-life system (3 hits = game over)

The game becomes more challenging over time through adaptive logic.

---

## Adaptive Difficulty (CoreML-Style System)
Even without a full ML model, the app uses an algorithm inspired by CoreML behavior.  
Difficulty adapts based on:
- Score  
- Time survived  
- Orbs collected  
- Hits taken  
- Remaining lives  
- Base difficulty selected by the user  

This simulates ML-driven prediction and demonstrates knowledge of AI-inspired game adjustment.

---

## Data Persistence (Core Data)
The app stores:
- High scores  
- Date of play  
- Selected difficulty  

These records are displayed in the High Scores screen for long-term progress tracking.

---

## Clean SwiftUI Navigation
The app includes multiple screens, all connected using a NavigationStack architecture:
- Home  
- Game  
- High Scores  
- Settings (difficulty and options)  

Sections are clearly organized for a smooth user experience.

---

# Image-Based Game Graphics
The game uses custom image assets instead of default shapes:
- Dinosaur sprite  
- Orb item  
- Cactus hazard  

This allows future expansion into full sprite animations or animated characters.

---

# Technologies Used
- **SwiftUI** – UI layout, navigation, state management  
- **SpriteKit** – 2D physics and gameplay  
- **Core Data** – persistent high score storage  
- **CoreML-style logic** – adaptive difficulty simulation  
- **Combine** – reactive state updates  
- **Xcode Asset Catalog** – for game graphics  

---

# Why This App Meets Assignment Requirements
- Includes more than three screens (Home, Game, High Scores, Settings)  
- Combines advanced UI with SpriteKit animations  
- Uses NavigationStack for modern SwiftUI architecture  
- Implements persistent data using Core Data  
- Integrates an emerging-tech inspired feature (CoreML-style adaptive difficulty)  
- Uses polished visual assets and clear theme  
- Defines its target audience  
- Provides opportunities for future expansion (animations, sound effects, real ML model, additional worlds)

