class_name BlueprintLoader
extends RefCounted
## BlueprintLoader handles loading data-driven entity blueprints (.jsonc / .json / .tres).
## Instantiates entity templates into active game objects without hardcoding.


## Load a blueprint specification file (.jsonc or .json) and return an EntityData resource.
static func load_blueprint(file_path: String) -> EntityData:
	if file_path.ends_with(".tres") or file_path.ends_with(".res"):
		return load(file_path) as EntityData

	var dict: Dictionary = JSONEntityLoader.load_json_file(file_path)
	if dict.is_empty():
		return null

	return JSONEntityLoader.dictionary_to_entity_data(dict)


## Instantiates an entity Node2D directly from a blueprint file path.
static func instantiate_blueprint(file_path: String) -> Node2D:
	var data: EntityData = load_blueprint(file_path)
	if not data:
		push_error("BlueprintLoader: Failed to load blueprint from - " + file_path)
		return null

	return data.create_entity_instance()
