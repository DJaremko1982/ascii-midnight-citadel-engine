# AGENTS.md

## Engine & Target Version
* **Engine:** Strictly **Godot 4.7** (`godot` CLI target `4.7.stable`).
* All code, GDScript syntax, APIs, and plugins MUST be compatible with **Godot 4.7**.

---

## Core Architectural Guarantees

To ensure the engine remains **reusable, moddable, extensible, and break-proof**, all additions to this codebase MUST follow these principles:

1. **Modularity & Addon Compatibility**: Features (e.g. ASCII shaders, AI solvers, inventory, proc-gen) must be self-contained modules or plugins. Adding or removing a plugin MUST NOT break core simulation logic.
2. **Signal-First & EventBus Decoupling**: Nodes and systems MUST NEVER use hardcoded node paths (`get_node("../Path")`) or mutate cross-tier objects directly. State updates MUST be communicated via Godot `signal` emission or `EventBus` events.
3. **Data-Driven Blueprints**: Game objects, items, enemies, and stats MUST be loaded from `.jsonc` or `.tres` blueprints via `BlueprintLoader`. Never hardcode game stats or magic numbers directly in GDScript.
4. **Reflective Registry Queries**: Use `Registry` and `has_method()` / `is_instance_valid()` for entity capabilities instead of rigid class inheritance casting.
5. **Deterministic Simulation**: All random logic MUST use `SeededRNG` and fixed tick passes via `SimClock`.

---

## GDScript Formatting & Verification Rules

When writing, editing, or refactoring `.gd` files in this repository, follow these verification rules:

### 1. Formatter & Linter Commands
Use the project's local virtual environment (`./.venv/bin/`) to run `gdtoolkit` tools via `run_command`:

* **Format check:**
  ```bash
  ./.venv/bin/gdformat --check path/to/script.gd
  ```
* **Auto-format:**
  ```bash
  ./.venv/bin/gdformat path/to/script.gd
  ```
* **Linting:**
  ```bash
  ./.venv/bin/gdlint path/to/script.gd
  ```

### 2. Unit Testing Rules (GUT v9.7.1)
Use **GUT 9.7.1** for unit testing:
* **Run tests in headless mode:**
  ```bash
  godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://test/ -gexit
  ```

### 3. Workflow Guidelines for AI Assistants
* **AI Rule Enforcement**: Yes, instructions in `AGENTS.md` are active rules automatically injected into the system prompt for AI assistants working in this repository.
* After editing any `.gd` file, run `./.venv/bin/gdformat` to maintain consistent GDScript 4 code style.
* Run `./.venv/bin/gdlint` to check for syntax errors, unneeded code, and missing variables before reporting completion.
* When adding or modifying core logic, create or update GUT unit tests in `test/` and run them headlessly with `godot --headless`.
