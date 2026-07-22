class_name DungeonGenerator
extends RefCounted
## Deterministic Procedural Dungeon Generator.
## Generates room-and-corridor maps using SeededRNG.

var map_width: int
var map_height: int
var seeded_rng: SeededRNG

## 2D grid storing map tile values ('#' = Wall, '.' = Floor).
var grid: Array[Array] = []
var rooms: Array[Rect2i] = []


func _init(width: int = 80, height: int = 45, p_seed: int = 12345) -> void:
	map_width = max(10, width)
	map_height = max(10, height)
	seeded_rng = SeededRNG.new(p_seed)


## Generate a dungeon layout with rooms and corridors.
func generate_dungeon(
	max_rooms: int = 12, min_room_size: int = 6, max_room_size: int = 14
) -> Vector2i:
	rooms.clear()
	grid.clear()

	# Fill grid with walls
	for y in range(map_height):
		var row: Array[String] = []
		for x in range(map_width):
			row.append("#")
		grid.append(row)

	for _i in range(max_rooms):
		var rw: int = seeded_rng.randi_range(min_room_size, max_room_size)
		var rh: int = seeded_rng.randi_range(min_room_size, max_room_size)
		var rx: int = seeded_rng.randi_range(1, map_width - rw - 1)
		var ry: int = seeded_rng.randi_range(1, map_height - rh - 1)

		var new_room: Rect2i = Rect2i(rx, ry, rw, rh)
		var intersects: bool = false
		for other in rooms:
			if new_room.grow(1).intersects(other):
				intersects = true
				break

		if not intersects:
			_carve_room(new_room)

			if not rooms.is_empty():
				var prev_center: Vector2i = rooms[-1].get_center()
				var new_center: Vector2i = new_room.get_center()
				_carve_corridor(prev_center, new_center)

			rooms.append(new_room)

	# Return the center of the first room (ideal player spawn location)
	if not rooms.is_empty():
		return rooms[0].get_center()
	return Vector2i(map_width / 2, map_height / 2)


func _carve_room(room: Rect2i) -> void:
	for y in range(room.position.y, room.end.y):
		for x in range(room.position.x, room.end.x):
			if x > 0 and x < map_width - 1 and y > 0 and y < map_height - 1:
				grid[y][x] = "."


func _carve_corridor(from_pos: Vector2i, to_pos: Vector2i) -> void:
	var cx: int = from_pos.x
	var cy: int = from_pos.y

	while cx != to_pos.x:
		grid[cy][cx] = "."
		cx += 1 if to_pos.x > cx else -1

	while cy != to_pos.y:
		grid[cy][cx] = "."
		cy += 1 if to_pos.y > cy else -1
