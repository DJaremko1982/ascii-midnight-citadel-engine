class_name SimClock
extends Node
## Deterministic Simulation Clock & Turn Controller
## Manages tick-based simulation updates independent of rendering frame-rates.

signal tick_advanced(current_tick: int)

var current_tick: int = 0
var is_paused: bool = false
var seeded_rng: SeededRNG


func _init(p_seed: int = 12345) -> void:
	seeded_rng = SeededRNG.new(p_seed)


## Advance the simulation by a fixed number of ticks (default 1).
func advance_tick(ticks: int = 1) -> int:
	if is_paused:
		return current_tick

	for i in range(ticks):
		current_tick += 1
		tick_advanced.emit(current_tick)

	return current_tick


## Reset simulation tick counter and re-seed the PRNG.
func reset(p_seed: int = 12345) -> void:
	current_tick = 0
	is_paused = false
	seeded_rng.set_seed(p_seed)
