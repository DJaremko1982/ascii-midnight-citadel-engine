class_name BaseComponent
extends Node
## Base class for all reusable entity components in the logic layer.
## Emits events when attached/detached and provides lifecycle hooks.

signal component_attached(entity: Node)
signal component_detached(entity: Node)

## Reference to the owner entity node.
var entity: Node = null


func _enter_tree() -> void:
	entity = get_parent()
	if entity:
		_on_attached(entity)
		component_attached.emit(entity)


func _exit_tree() -> void:
	if entity:
		_on_detached(entity)
		component_detached.emit(entity)
		entity = null


## Virtual lifecycle method called when component is attached to an entity.
func _on_attached(_entity: Node) -> void:
	pass


## Virtual lifecycle method called when component is detached from an entity.
func _on_detached(_entity: Node) -> void:
	pass
