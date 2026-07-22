extends GutTest

var _movement_system: MovementSystem
var _entity: Node2D
var _pos_comp: PositionComponent


func before_each() -> void:
	_movement_system = MovementSystem.new()
	_movement_system.move_cooldown_sec = 0.0  # Disable cooldown during unit testing
	_entity = Node2D.new()
	_pos_comp = PositionComponent.new()
	_pos_comp.name = "PositionComponent"
	_entity.add_child(_pos_comp)
	add_child_autofree(_entity)
	add_child_autofree(_movement_system)


func test_position_component_move() -> void:
	_pos_comp.grid_position = Vector2i(5, 5)
	_pos_comp.move_by(Vector2i(1, 0))
	assert_eq(_pos_comp.grid_position, Vector2i(6, 5), "Position should advance by (1, 0)")


func test_realtime_movement_system() -> void:
	_pos_comp.grid_position = Vector2i(10, 10)
	var bounds: Rect2i = Rect2i(0, 0, 20, 20)

	var moved: bool = _movement_system.move_entity(_entity, Vector2i(0, -1), bounds)
	assert_true(moved, "Moving inside bounds should return true")
	assert_eq(_pos_comp.grid_position, Vector2i(10, 9), "Entity should move up to (10, 9)")


func test_movement_system_out_of_bounds() -> void:
	_pos_comp.grid_position = Vector2i(0, 0)
	var bounds: Rect2i = Rect2i(0, 0, 10, 10)

	var moved: bool = _movement_system.move_entity(_entity, Vector2i(-1, 0), bounds)
	assert_false(moved, "Out of bounds move should be rejected")
	assert_eq(_pos_comp.grid_position, Vector2i(0, 0), "Position should remain unchanged")
