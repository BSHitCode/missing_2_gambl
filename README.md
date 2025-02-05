# GamblingGame
**Contributors**
   - FelixWoess: k12206357
   - Cornelius Engl: k12216183
   - ziraelexe: k12209550

## Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/BSHitCode/missing_2_gambl.git
   ```

2. **Install Godot 4 - .NET Version AND .NET**
   - Windows: [Godot Engine 4+ - .NET](https://godotengine.org/download).
   - Linux:  [Godot Engine 4+ - .NET](https://godotengine.org/download/linux/).
  
   - .NET 7 or newer: [.NET >=7](https://dotnet.microsoft.com/en-us/).

3. **Open the Project**
   - Launch Godot Engine.
   - Open the project by selecting the `missing_2_gambl` folder.

## Execution

### In Editor
1. **Run the Game**
   - Open the project in Godot Engine.
   - Click the play button (▶) at the top-right corner of the Godot editor to start the game.

2. **Export the Game (Optional)**
   - Use Godot's export options to create executable builds for your desired platform (Windows, Linux, etc.).
   - Project -> Export -> Add... (next to the word "Presets")
  
### Using compiled file (ONLY on with-exec branch -> excluded because it adds 100MB)
1. **Run the Game**
   - Windows: Open `GamblingGame.exe` (x86_64)
   - Linux: Open `GamblingGameLinux.x86_64` (x86_64)
   - Linux: Open `GamblingGameLinux.arm64` (arm64)
   - For others please export on your own using the previous explaination (preferred).
   
2. **Run Linux Binary**
   - `uname -m`
   - `./GamblingGameLinux.x86_64`
