class_name Registry
extends Node
## Global Reflective Entity & Component Registry
## Enables runtime query-by-trait and entity capability registration.

## Dictionary of StringName (component_name) -> Array of Entity Nodes
var _component_index: Dictionary = {}


## Register an entity component in the index.
func register_component(component_name: StringName, entity: Node) -> void:
	if not _component_index.has(component_name):
		_component_index[component_name] = []

	var list: Array = _component_index[component_name]
	if not list.has(entity):
		list.append(entity)


## Unregister an entity component from the index.
func unregister_component(component_name: StringName, entity: Node) -> void:
	if not _component_index.has(component_name):
		return

	var list: Array = _component_index[component_name]
	list.erase(entity)
	if list.is_empty():
		_component_index.erase(component_name)


## Query all entities that possess a specific component trait.
func get_entities_with_component(component_name: StringName) -> Array[Node]:
	if not _component_index.has(component_name):
		return []

	var result: Array[Node] = []
	var list: Array = _component_index[component_name]
	for item in list:
		if is_instance_valid(item):
			result.append(item as Node)
	return result


## Query entities that possess ALL of the specified component traits.
func get_entities_with_all(component_names: Array[StringName]) -> Array[Node]:
	if component_names.is_empty():
		return []

	var candidates: Array[Node] = get_entities_with_component(component_names[0])
	if candidates.is_empty():
		return []

	var matching: Array[Node] = []
	for candidate in candidates:
		var has_all: bool = true
		for i in range(1, component_names.size()):
			var list: Array = _component_index.get(component_names[i], [])
			if not list.has(candidate):
				has_all = false
				break
		if has_all:
			matching.append(candidate)

	return matching


## Clear the entire registry index.
func clear() -> void:
	_component_index.clear()
