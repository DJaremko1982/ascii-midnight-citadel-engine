class_name SeededRNG
extends RefCounted
## Deterministic Seeded Pseudo-Random Number Generator (PRNG)
## Wraps Godot's RandomNumberGenerator for reproducible state simulation and replayability.

var initial_seed: int = 0
var state_step_count: int = 0
var _rng: RandomNumberGenerator


func _init(p_seed: int = 0) -> void:
	_rng = RandomNumberGenerator.new()
	set_seed(p_seed)


## Set the PRNG seed and reset the step counter.
func set_seed(p_seed: int) -> void:
	initial_seed = p_seed
	_rng.seed = p_seed
	state_step_count = 0


## Return a pseudo-random integer in range [min_val, max_val].
func randi_range(min_val: int, max_val: int) -> int:
	state_step_count += 1
	return _rng.randi_range(min_val, max_val)


## Return a pseudo-random float in range [min_val, max_val].
func randf_range(min_val: float, max_val: float) -> float:
	state_step_count += 1
	return _rng.randf_range(min_val, max_val)


## Return a pseudo-random float in range [0.0, 1.0].
func randf() -> float:
	state_step_count += 1
	return _rng.randf()


## Pick a random element from an array deterministically.
func choice(array: Array) -> Variant:
	if array.is_empty():
		return null
	var idx: int = randi_range(0, array.size() - 1)
	return array[idx]
