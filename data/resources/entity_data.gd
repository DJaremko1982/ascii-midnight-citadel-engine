class_name EntityData
extends Resource
## Data-Driven Custom Resource defining an Entity template.
## Defines stats, visual glyphs, and attached component configurations without hardcoding.

@export var entity_id: StringName = &"unnamed_entity"
@export var display_name: String = "Unnamed Entity"
@export var ascii_char: String = "?"
@export var foreground_color: Color = Color.WHITE
@export var background_color: Color = Color.BLACK
@export var max_health: int = 100
@export var components_to_add: Array[StringName] = []


func create_entity_instance() -> Node2D:
	var entity_node: Node2D = Node2D.new()
	entity_node.name = str(entity_id)

	if components_to_add.has(&"HealthComponent"):
		var health_comp: HealthComponent = HealthComponent.new()
		health_comp.name = "HealthComponent"
		health_comp.max_health = max_health
		entity_node.add_child(health_comp)

	return entity_node
