extends GutTest


func test_strip_jsonc_comments() -> void:
	var jsonc_text: String = '{\n// single line comment\n"name": "test"\n/* multi\nline */\n}'
	var clean_text: String = JSONEntityLoader.strip_json_comments(jsonc_text)
	assert_true(
		not clean_text.contains("// single line comment"), "Single line comments should be removed"
	)
	assert_true(not clean_text.contains("/* multi"), "Multi line comments should be removed")


func test_load_jsonc_entity_spec() -> void:
	var dict: Dictionary = JSONEntityLoader.load_json_file("res://data/presets/goblin_scout.jsonc")
	assert_false(dict.is_empty(), "JSONC dict should not be empty")
	assert_eq(dict["entity_id"], "goblin_scout", "Entity ID should match 'goblin_scout'")
	assert_eq(dict["ascii_char"], "g", "ASCII char should match 'g'")

	var entity_data: EntityData = JSONEntityLoader.dictionary_to_entity_data(dict)
	assert_not_null(entity_data, "EntityData should be instantiated from JSONC")
	assert_eq(entity_data.max_health, 45, "Max health should match 45")

	var instance: Node2D = entity_data.create_entity_instance()
	add_child_autofree(instance)
	var health_comp: HealthComponent = (
		instance.get_node_or_null("HealthComponent") as HealthComponent
	)
	assert_not_null(
		health_comp, "Instantiated entity from JSONC should have HealthComponent attached"
	)
	assert_eq(health_comp.max_health, 45, "HealthComponent max_health should match 45")
