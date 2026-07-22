class_name JSONEntityLoader
extends RefCounted
## Utility class to load and parse JSON / JSONC entity specification files.
## Converts JSON specifications directly into EntityData resources or Node2D instances.


## Strip JSONC comments (single line // and multi-line /* ... */) from a string.
static func strip_json_comments(json_text: String) -> String:
	var result: String = json_text

	# Strip multi-line /* ... */ comments
	var block_start: int = result.find("/*")
	while block_start != -1:
		var block_end: int = result.find("*/", block_start + 2)
		if block_end != -1:
			result = result.substr(0, block_start) + result.substr(block_end + 2)
		else:
			break
		block_start = result.find("/*")

	# Strip single-line // comments line by line
	var lines: PackedStringArray = result.split("\n")
	var clean_lines: PackedStringArray = []
	for line in lines:
		var comment_idx: int = line.find("//")
		if comment_idx != -1:
			clean_lines.append(line.substr(0, comment_idx))
		else:
			clean_lines.append(line)

	return "\n".join(clean_lines)


## Load a JSON/JSONC file from disk and return a Dictionary.
static func load_json_file(file_path: String) -> Dictionary:
	if not FileAccess.file_exists(file_path):
		push_error("JSONEntityLoader: File not found - " + file_path)
		return {}

	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return {}

	var raw_text: String = file.get_as_text()
	file.close()

	var clean_text: String = strip_json_comments(raw_text)
	var json: JSON = JSON.new()
	var parse_result: Error = json.parse(clean_text)

	if parse_result != OK:
		push_error(
			(
				"JSONEntityLoader: Failed to parse JSON file "
				+ file_path
				+ " at line "
				+ str(json.get_error_line())
			)
		)
		return {}

	if json.data is Dictionary:
		return json.data as Dictionary
	return {}


## Parse a Dictionary specification into an EntityData resource.
static func dictionary_to_entity_data(dict: Dictionary) -> EntityData:
	var entity_data: EntityData = EntityData.new()

	if dict.has("entity_id"):
		entity_data.entity_id = StringName(dict["entity_id"])
	if dict.has("display_name"):
		entity_data.display_name = str(dict["display_name"])
	if dict.has("ascii_char"):
		entity_data.ascii_char = str(dict["ascii_char"])
	if dict.has("max_health"):
		entity_data.max_health = int(dict["max_health"])

	if dict.has("components") and dict["components"] is Array:
		var comps: Array[StringName] = []
		for c in dict["components"]:
			comps.append(StringName(str(c)))
		entity_data.components_to_add = comps

	return entity_data
