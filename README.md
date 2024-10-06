# Blood From The Queen

## Card Placement

### Example for Security Officer

Grid View:

- `F` - Where the card is place
- `X` - Affected Tiles

```text
. . . . .
. . X . .
. X F X .
. . X . .
. . . . .
```

JSON:

```json
"placement": [
    [0, 0],   # Center (where the card is placed)
    [0, 1],   # Up
    [1, 0],   # Right
    [0, -1],  # Down
    [-1, 0]   # Left
]
```

### Example for Fleetwing

Grid View:

- `F` - Where the card is place
- `X` - Affected Tiles

```text
X . . . .
. X . . .
. . F . .
. X . . .
X . . . .
```

JSON:

```json
"placement": [
    [0, 0],    # Center (always included)
    [-2, 2],   # Top-left diagonal (2 up, 2 left)
    [-1, 1],   # Top-left closer diagonal (1 up, 1 left)
    [-1, -1],  # Bottom-left closer diagonal (1 down, 1 left)
    [-2, -2],  # Bottom-left diagonal (2 down, 2 left)
    [0, 2],    # 2 up
    [0, -2]    # 2 down
]
```