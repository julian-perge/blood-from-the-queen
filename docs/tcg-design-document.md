# TCG Design Document: Queen's Blood

## 1. Game Overview
Queen's Blood is a strategic Trading Card Game (TCG) implemented in the Godot engine. Players compete to score the most points by strategically placing cards on a 7x3 grid board divided into lanes.

## 2. Core Mechanics

### 2.1 Board Layout
- The game board consists of 7 columns and 3 lanes (rows), forming a 7x3 grid.
- Column 1 (leftmost) displays the player's points for each lane.
- Column 7 (rightmost) displays the enemy's points for each lane.
- Columns 2-6 form the playable area, divided into 5 lanes.

### 2.2 Turn Structure
- Players take alternating turns to place cards in the playable area (columns 2-6).
- On their turn, a player can either place a card or pass (holding triangle button).
- Cards can only be placed on squares with an emerald pawn (available position).

### 2.3 Card Placement
- When a card is selected from the hand, valid placement squares are highlighted within the playable area.
- A card is played by having one of its yellow tiles overlap with an available position in the playable area.
- When played, the card's value is added to the lane's total score for the player.
- Playing a card can add new emerald pawns to adjacent squares, including diagonally.

### 2.4 Scoring
- Each lane has a point total for both players, displayed in columns 1 and 7.
- The player with the highest total score across all lanes at the end of the game wins.

## 3. Card Attributes

### 3.1 Card Value
- Represented by a yellow number in the top right corner of the card.
- Contributes to the lane's total score when played.

### 3.2 Card Rank
- Indicated by the number of pawn symbols in the upper left corner of the card.
- Determines which positions the card can be played on (equal to or higher than its rank).

### 3.3 Position Tiles
- Shown as yellow squares at the bottom middle of the card.
- Indicate where new positions (emerald pawns) will be added to the board when the card is played.

### 3.4 Abilities
- Some cards have special abilities, such as "Raise power by 1 for each other enhanced allied card."
- Abilities can affect the player's own cards or opponent's cards on the affected tiles.

## 4. Gameplay Progression

### 4.1 Position Ranking
- When a played card's position tile overlaps with an already available position, it ranks up.
- Ranking up is indicated by multiple emerald pawns in the same square.
- Positions can rank up to a maximum of Rank 3.

### 4.2 Playing Higher Rank Cards
- To play more powerful cards, players need to level up their available positions.
- Leveling up is achieved by playing cards with overlapping position tiles near existing positions.

### 4.3 Position Control
- Players can place emerald pawns (their control) on empty squares or squares with red pawns (enemy control).
- The opponent can reclaim positions using the same mechanic.

## 5. User Interface

### 5.1 Hand Display
- Player's hand is shown at the bottom of the screen.
- Selected cards are highlighted.
- Card details, including abilities, are displayed when a card is hovered over.

### 5.2 Board Display
- The 7x3 grid is clearly visible, with the playable 5x3 area distinguished from the scoring columns.
- Available positions are marked with emerald pawns within the playable area.
- Opponent's positions are marked with red pawns within the playable area.
- Placed cards show their value and any active abilities in the playable lanes.
- The leftmost and rightmost columns display scores prominently.

### 5.3 Score Display
- Each lane's score for both players is displayed in the leftmost (player) and rightmost (enemy) columns.

### 5.4 Turn Indicator
- A clear "Your Turn" message is displayed when it's the player's turn to act.

### 5.5 Pass Option
- A "Pass" option is available, indicated by a button prompt (e.g., "△ Pass").

## 6. Visual Style
- Card art features fantasy-themed characters and creatures.
- The game board has a mystical, regal appearance with ornate designs.
- Colors are used to clearly differentiate player controls (emerald) from opponent controls (red).
- The board is set on an ornate table with decorative elements surrounding it.

## 7. Implementation Notes for Godot

### 7.1 Card System
- Implement a Card class with properties for value, rank, position tiles, and abilities.
- Use Godot's built-in drag-and-drop functionality for card placement.

### 7.2 Board Logic
- Create a 7x3 grid using Godot's TileMap or GridContainer, with special logic for the scoring columns.
- Implement logic to handle position ranking and control within the 5x3 playable area.
- Develop a scoring system that updates the left and right columns based on the playable area's state.

### 7.3 UI Elements
- Utilize Godot's Control nodes for creating the user interface.
- Implement a highlighting system for available positions and selected cards.
- Create a turn indicator and pass option button.

### 7.4 Game State Management
- Use Godot's built-in networking capabilities for multiplayer functionality.
- Implement a state machine to manage game flow and turn order.

## 8. Future Enhancements
- Implement a deck-building system.
- Add single-player mode with AI opponents.
- Create a tutorial system for new players.
- Develop additional card abilities and effects to increase strategic depth.
