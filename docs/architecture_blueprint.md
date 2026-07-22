# Architectural Blueprint: ASCII Midnight Citadel Engine

This document outlines the core architecture for the **ASCII Midnight Citadel Engine** in Godot 4.7. The engine design enforces strict 6-tier separation of concerns, paired with decoupled event-driven communication and deterministic state management.

---

## 1. Core 6-Tier Architecture

```mermaid
graph TD
    subgraph Core ["⚙️ CORE LAYER (Infrastructure & Utilities)"]
        C1[Global EventBus & Command Hub]
        C2[Save/Load & Serialization]
        C3[Logger & Math Utilities]
    end

    subgraph DataAssets ["📁 DATA & ASSETS LAYER (Pure Content)"]
        D1[Custom Godot Resources .tres]
        D2[Media Assets: Fonts, Audio, Textures]
    end

    subgraph Logic ["🧠 LOGIC LAYER (Headless Rules & ECS)"]
        L1[Entities & Reusable Components]
        L2[Deterministic Systems & Turn Clock]
    end

    subgraph Render ["🎨 RENDER LAYER (Low-Level Presentation)"]
        R1[ASCII Terminal & Viewports]
        R2[Custom Shaders & Draw Drivers]
    end

    subgraph Interface ["🖥️ INTERFACE LAYER (UI & Input Drivers)"]
        I1[Input Action Mappers]
        I2[Menus & HUD Displays]
    end

    subgraph Pipeline ["🛠️ PIPELINE LAYER (Generators & Content Tools)"]
        P1[Procedural Dungeon Generators]
        P2[Editor Pipelines & Seed Solvers]
    end

    D1 -->|Loaded by| L1
    L1 -->|Emits Events via| C1
    C1 -->|Triggers Presentation| R1
    C1 -->|Updates UI| I2
    P1 -->|Generates Map Data| D1
```

### Key Architectural Tiers
1. **`core/` (Core Engine Services)**: Infrastructure utilities, global `EventBus`, save-state serialization, logging, and core math helpers.
2. **`assets/` & `data/` (Data & Media)**: Custom `.tres` resource scripts, JSON configs, fonts, textures, and audio. Contains NO execution logic.
3. **`logic/` (Gameplay Rules & Systems)**: Pure headless game logic, ECS components, turn order, and deterministic simulation algorithms.
4. **`render/` (Presentation & Graphics)**: Low-level rendering, ASCII terminal grid driver, shaders, and viewport management.
5. **`interface/` (UI & User Interaction)**: Input action mappers, menus, HUDs, and terminal UI controls.
6. **`pipeline/` (Generators & Tooling)**: Procedural map/dungeon generators, seed solvers, content creation tools, and build pipelines.

---

## 2. Directory Structure

```
ascii-midnight-citadel-engine/
├── AGENTS.md                  # Project rules & GDScript 4.7 formatting instructions
├── project.godot
│
├── assets/                    # PURE MEDIA ASSETS (Fonts, Audio, Textures)
│   ├── audio/
│   ├── fonts/
│   └── textures/
│
├── core/                      # ENGINE INFRASTRUCTURE (EventBus, Serializer, Logger)
│   ├── event_bus.gd
│   ├── registry.gd
│   ├── serializer.gd
│   └── logger.gd
│
├── data/                      # PURE DATA DEFINITIONS (Custom .tres resources & presets)
│   ├── presets/
│   └── resources/
│
├── logic/                     # PURE GAME LOGIC (Headless-compatible ECS & Simulation)
│   ├── components/
│   ├── entities/
│   └── systems/
│
├── render/                    # LOW-LEVEL PRESENTATION (ASCII terminal, Viewports, Shaders)
│   ├── ascii/
│   ├── shaders/
│   └── viewport/
│
├── interface/                 # UI & USER INTERACTION (HUD, Menus, Input Drivers)
│   ├── hud/
│   ├── input/
│   └── menus/
│
├── pipeline/                  # GENERATORS & TOOLING (Dungeon Proc-Gen, Seed Solvers)
│   ├── proc_gen/
│   └── tools/
│
├── plugins/                   # Addons & Extensions (e.g. MCP Server)
├── test/                      # GUT 9.7.1 Automated Unit Tests
└── docs/                      # Technical Documentation & Specifications
```
