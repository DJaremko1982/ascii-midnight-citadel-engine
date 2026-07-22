extends Node2D
## Main Playable Scene Driver
## Integrates real-time movement, dungeon procedural generation, and pixel-perfect ASCII rendering.

var dungeon_gen: DungeonGenerator
var movement_system: MovementSystem
var player_entity: Node2D
var player_pos_comp: PositionComponent
var map_bounds: Rect2i

@onready var grid_renderer: ASCIIGridRenderer = $ASCIIGridRenderer


func _ready() -> void:
	movement_system = MovementSystem.new()
	movement_system.move_cooldown_sec = 0.08  # Real-time responsiveness
	add_child(movement_system)

	# Generate procedural dungeon map
	var grid_w: int = 80
	var grid_h: int = 45
	map_bounds = Rect2i(0, 0, grid_w, grid_h)
	dungeon_gen = DungeonGenerator.new(grid_w, grid_h, 2026)
	var spawn_pos: Vector2i = dungeon_gen.generate_dungeon(14)

	# Instantiate player from blueprint
	player_entity = BlueprintLoader.instantiate_blueprint("res://data/presets/player_preset.tres")
	if player_entity:
		player_pos_comp = PositionComponent.new()
		player_pos_comp.name = "PositionComponent"
		player_pos_comp.grid_position = spawn_pos
		player_entity.add_child(player_pos_comp)
		add_child(player_entity)

	# Connect position change signal to redraw ASCII frame
	if player_pos_comp:
		player_pos_comp.position_changed.connect(_on_player_position_changed)

	_render_frame()


func _process(_delta: float) -> void:
	if not player_entity:
		return

	# Read real-time keyboard inputs
	var move_dir: Vector2i = Vector2i.ZERO
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		move_dir.y -= 1
	elif Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		move_dir.y += 1

	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		move_dir.x -= 1
	elif Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		move_dir.x += 1

	if move_dir != Vector2i.ZERO:
		# Check wall collision before moving
		var target_pos: Vector2i = player_pos_comp.grid_position + move_dir
		if (
			target_pos.x >= 0
			and target_pos.x < dungeon_gen.map_width
			and target_pos.y >= 0
			and target_pos.y < dungeon_gen.map_height
		):
			if dungeon_gen.grid[target_pos.y][target_pos.x] == ".":
				movement_system.move_entity(player_entity, move_dir, map_bounds)


func _on_player_position_changed(_new_pos: Vector2i) -> void:
	_render_frame()


func _render_frame() -> void:
	if not grid_renderer or not grid_renderer.buffer:
		return

	var buffer: ASCIIGridBuffer = grid_renderer.buffer
	buffer.clear_buffer(" ", Color.WHITE, Color.BLACK)

	# Draw procedural dungeon walls and floor tiles
	for y in range(dungeon_gen.map_height):
		for x in range(dungeon_gen.map_width):
			var tile: String = dungeon_gen.grid[y][x]
			if tile == "#":
				buffer.set_cell(x, y, "#", Color(0.3, 0.3, 0.4), Color(0.05, 0.05, 0.08))
			else:
				buffer.set_cell(x, y, ".", Color(0.15, 0.2, 0.25), Color(0.02, 0.02, 0.04))

	# Draw player @ character in the middle of the dungeon
	if player_pos_comp:
		var px: int = player_pos_comp.grid_position.x
		var py: int = player_pos_comp.grid_position.y
		buffer.set_cell(px, py, "@", Color(0.2, 0.9, 1.0), Color(0.0, 0.2, 0.3))

	grid_renderer.queue_redraw()
