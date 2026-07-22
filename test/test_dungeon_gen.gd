extends GutTest

var _dungeon_gen: DungeonGenerator


func before_each() -> void:
	_dungeon_gen = DungeonGenerator.new(40, 25, 42)


func test_dungeon_generation() -> void:
	var spawn_pos: Vector2i = _dungeon_gen.generate_dungeon(6)
	assert_false(_dungeon_gen.rooms.is_empty(), "Dungeon should generate rooms")
	assert_eq(
		_dungeon_gen.grid[spawn_pos.y][spawn_pos.x],
		".",
		"Spawn position should be a carved floor tile '.'"
	)


func test_dungeon_determinism() -> void:
	var gen1: DungeonGenerator = DungeonGenerator.new(40, 25, 777)
	var spawn1: Vector2i = gen1.generate_dungeon()

	var gen2: DungeonGenerator = DungeonGenerator.new(40, 25, 777)
	var spawn2: Vector2i = gen2.generate_dungeon()

	assert_eq(spawn1, spawn2, "Identical seeds must generate identical spawn locations")
