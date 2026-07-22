class_name MovementSystem
extends Node
## Realtime Grid Movement System.
## Handles real-time input processing, velocity, grid collision checks, and position updates.

signal entity_moved(entity: Node, new_pos: Vector2i)

var move_cooldown_sec: float = 0.12
var _cooldown_timers: Dictionary = {}


## Process movement direction vector for an entity.
func move_entity(entity: Node, direction: Vector2i, map_bounds: Rect2i = Rect2i()) -> bool:
	if direction == Vector2i.ZERO or not is_instance_valid(entity):
		return false

	var pos_comp: PositionComponent = (
		entity.get_node_or_null("PositionComponent") as PositionComponent
	)
	if not pos_comp:
		return false

	# Check movement cooldown for real-time responsiveness
	var entity_id: int = entity.get_instance_id()
	var current_time: float = Time.get_ticks_msec() / 1000.0
	if _cooldown_timers.has(entity_id):
		if current_time - _cooldown_timers[entity_id] < move_cooldown_sec:
			return false

	var target_pos: Vector2i = pos_comp.grid_position + direction

	# Optional map boundary check
	if map_bounds.size != Vector2i.ZERO and not map_bounds.has_point(target_pos):
		return false

	_cooldown_timers[entity_id] = current_time
	pos_comp.grid_position = target_pos
	entity_moved.emit(entity, target_pos)
	return true
