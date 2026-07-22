class_name PositionComponent
extends BaseComponent
## Grid and World position component for entities.

signal position_changed(new_grid_pos: Vector2i)

@export var grid_position: Vector2i = Vector2i.ZERO:
	set(val):
		if grid_position != val:
			grid_position = val
			position_changed.emit(grid_position)


func move_by(delta: Vector2i) -> Vector2i:
	grid_position += delta
	return grid_position
