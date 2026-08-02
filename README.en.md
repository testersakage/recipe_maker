# 🛠️ Craft Recipe Maker (Code & JSON Generator)

- [Japanese Documentation (README.md)](./README.md)

A standalone graphical development utility for Luanti (Minetest) modding. 
By placing items into a visual 3x3 grid directly in-game, this tool scans the core inventory database to generate 100% accurate, typo-free Lua craft code and data-driven JSON arrays instantly.

It perfectly solves the nightmare of missing namespaces or fluctuating item IDs caused by game version updates (e.g., VoxeLibre / Mineclonia / Minetest Game).

## 🌟 Key Features

- **Direct In-Game ID Scan**: Drag and drop real blocks into the grid. It reads the internal `core.registered_items` database to fetch the absolute correct name.
- **Dual Format Output**: Generates both standard Luanti `core.register_craft` Lua code and modern data-driven JSON array formats (`"recipe": [ ... ]`) simultaneously.
- **Optimized UI Design**: Features ultra-compact `0.6x` slot scaling to easily see your whole inventory, paired with a semi-transparent dark background for peak visibility.
- **Drop-on-Break Safety**: If broken with items inside, it breaks smoothly and scatters all stored ingredients onto the ground without any inventory locking.

## 🛠️ Installation

1. Download this repository as a ZIP file or clone it using git.
2. Extract/move the folder into your Luanti `mods/` directory.
3. Rename the folder to exactly `recipe_maker`.
4. Enable the mod in your world configuration menu.

## 💻 System Requirements

- **Minimum Requirement**: **Luanti v5.4.0 or later** (Required for sub-grid UI features).
- **Recommended Requirement**: **Luanti v5.15.2 or later** (Highly recommended for optimal engine performance and patch-level security updates).

## 🚀 How to Use

1. Take the **Craft Recipe Maker** (`recipe_maker:generator`) from your creative inventory and place it on the ground.
2. Right-click the block to open the advanced workspace.
3. Place your ingredients into the 3x3 grid on the left, and your desired outcome into the single output slot on the right.
4. Click the **Generate Code** button.
5. Simply copy the generated Lua or JSON text array from the box below directly into your mod files!

## 📄 License

This mod is released under the **MIT License**. See the `LICENSE` file for details.

**AI-generated**: This package contains AI-generated assets or code
