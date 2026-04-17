# 🎭 Under Your Mask

<p align="center">
  <a href="https://zer0lul.itch.io/under-your-mask">
    <img src="https://img.shields.io/badge/Play_on-itch.io-FA5C5C?style=for-the-badge&logo=itch.io" alt="Play on itch.io" />
  </a>
  <a href="https://godotengine.org/">
    <img src="https://img.shields.io/badge/Made_with-Godot_4-478CBF?style=for-the-badge&logo=godot-engine" alt="Made with Godot 4" />
  </a>
</p>

<p align="center">
  <img src="UnderYourMaskGIF.gif" width="45%" alt="Under Your Mask Gameplay" />
  <img src="uymminiatura.png" width="45%" alt="Under Your Mask Thumbnail" />
</p>

## 📖 Project Context

**Under Your Mask** is a 2D pixel art puzzle-platformer developed entirely in **4 days** as my first entry for the **Global Game Jam 2026**. 

The game explores a dark narrative about identity, trust, and the price of freedom, combining agile platforming mechanics, environmental puzzle-solving, and a challenging boss fight with rhythmic synchronization.

## 🛠️ Systems & Engineering (Under the hood)

As a developer, I focused this project on building robust and scalable logical systems within Godot Engine:

* **Dynamic Dialog System (JSON):** A modular dialog architecture separated from the main codebase. It allows for easy script injection, typewriter-style text speed control, and randomized audio pitch modulation for character "voices".
* **Boss State Machine:** Combat logic structured in progressive, HP-dependent phases. It implements predictable yet rhythmic attacks that avoid pure RNG to ensure a fair "deadly dance" pattern for the player.
* **Animation-Code Synchronization (Freeze-Frame):** A mathematical impact system where the playback speed of `AnimationPlayers` scales dynamically (`playback_speed = base_duration / attack_duration`), combined with micro-pauses (`await`) to generate a deep sense of "weight" (Game Feel) in the final strikes.
* **Scene & Transition Management:** Intensive use of `CanvasLayer` and `Tweens` for visual fades, cinematics, and transition curtains without blocking the engine's main physics thread.

## 🚀 Installation & Local Execution

If you want to test the project directly in the engine:
1. Clone this repository: `git clone https://github.com/Zer0LoL/under-your-mask.git`
2. Open **Godot Engine 4.x**.
3. Import the `project.godot` file.
4. Press F5 to run the game.

---
*Developed by [Alvaro Roldan](https://github.com/Zer0LoL)*