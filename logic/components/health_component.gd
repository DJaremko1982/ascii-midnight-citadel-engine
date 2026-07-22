class_name HealthComponent
extends BaseComponent
## Reusable health component for entities.

signal health_changed(current_health: int, max_health: int)
signal died

@export var max_health: int = 100:
	set(val):
		max_health = max(1, val)
		current_health = min(current_health, max_health)

var current_health: int = 100


func _ready() -> void:
	current_health = max_health


## Apply damage to the entity.
func take_damage(amount: int) -> int:
	if amount <= 0 or current_health <= 0:
		return current_health

	current_health = max(0, current_health - amount)
	health_changed.emit(current_health, max_health)

	if current_health == 0:
		died.emit()

	return current_health


## Heal the entity.
func heal(amount: int) -> int:
	if amount <= 0 or current_health <= 0:
		return current_health

	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)
	return current_health


## Check if the entity is dead.
func is_dead() -> bool:
	return current_health <= 0
