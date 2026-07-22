extends GutTest


func test_blueprint_loader_jsonc() -> void:
	var blueprint_path: String = "res://data/presets/goblin_scout.jsonc"
	var entity_data: EntityData = BlueprintLoader.load_blueprint(blueprint_path)

	assert_not_null(entity_data, "BlueprintLoader should load JSONC blueprint")
	assert_eq(entity_data.entity_id, &"goblin_scout", "Blueprint ID should match 'goblin_scout'")

	var entity_node: Node2D = BlueprintLoader.instantiate_blueprint(blueprint_path)
	add_child_autofree(entity_node)

	assert_not_null(entity_node, "Instantiated node from blueprint should not be null")
	var health_comp: HealthComponent = (
		entity_node.get_node_or_null("HealthComponent") as HealthComponent
	)
	assert_not_null(health_comp, "Instantiated blueprint should have HealthComponent attached")


func test_blueprint_loader_tres() -> void:
	var preset_path: String = "res://data/presets/player_preset.tres"
	var entity_data: EntityData = BlueprintLoader.load_blueprint(preset_path)

	assert_not_null(entity_data, "BlueprintLoader should load .tres blueprint")
	assert_eq(entity_data.entity_id, &"hero_player", "Blueprint ID should match 'hero_player'")
