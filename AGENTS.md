# AGENTS.md

## Engine & Target Version
* **Engine:** Strictly **Godot 4.7** (`godot` CLI target `4.7.stable`).
* All code, GDScript syntax, APIs, and plugins MUST be compatible with **Godot 4.7**.

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
