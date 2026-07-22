extends GutTest

var _sim_clock: SimClock


func before_each() -> void:
	_sim_clock = SimClock.new(42)


func after_each() -> void:
	_sim_clock.free()


func test_seeded_rng_determinism() -> void:
	var rng1: SeededRNG = SeededRNG.new(12345)
	var rng2: SeededRNG = SeededRNG.new(12345)

	var val1_a: int = rng1.randi_range(1, 100)
	var val1_b: int = rng1.randi_range(1, 100)

	var val2_a: int = rng2.randi_range(1, 100)
	var val2_b: int = rng2.randi_range(1, 100)

	assert_eq(val1_a, val2_a, "Identical seeds must yield identical first random integer")
	assert_eq(val1_b, val2_b, "Identical seeds must yield identical second random integer")
	assert_eq(rng1.state_step_count, 2, "Step count should track generated values")


func test_seeded_rng_choice() -> void:
	var rng: SeededRNG = SeededRNG.new(999)
	var choices: Array = ["apple", "banana", "cherry"]
	var picked: Variant = rng.choice(choices)

	assert_true(choices.has(picked), "Choice must return an element from the array")


func test_sim_clock_advance() -> void:
	assert_eq(_sim_clock.current_tick, 0, "Initial tick should be 0")

	_sim_clock.advance_tick(5)
	assert_eq(_sim_clock.current_tick, 5, "Tick should advance to 5")


func test_sim_clock_reset() -> void:
	_sim_clock.advance_tick(10)
	_sim_clock.reset(42)

	assert_eq(_sim_clock.current_tick, 0, "Reset should restore tick to 0")
