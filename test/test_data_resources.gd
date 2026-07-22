extends GutTest


func test_entity_data_resource_instantiation() -> void:
	var res: EntityData = load("res://data/presets/player_preset.tres") as EntityData
	assert_not_null(res, "Preset resource should load successfully")
	assert_eq(res.entity_id, &"hero_player", "Entity ID should match preset data")
	assert_eq(res.ascii_char, "@", "ASCII glyph should match '@'")
	assert_eq(res.max_health, 150, "Max health should match 150")

	var entity_instance: Node2D = res.create_entity_instance()
	add_child_autofree(entity_instance)

	var health_comp: HealthComponent = (
		entity_instance.get_node_or_null("HealthComponent") as HealthComponent
	)
	assert_not_null(health_comp, "Instantiated entity should have HealthComponent attached")
	assert_eq(
		health_comp.max_health, 150, "HealthComponent max_health should inherit from Resource"
	)


func test_ascii_palette_data() -> void:
	var palette: ASCIIPaletteData = ASCIIPaletteData.new()
	assert_eq(palette.wall_char, "#", "Wall char default should be '#'")
	assert_eq(palette.floor_char, ".", "Floor char default should be '.'")
