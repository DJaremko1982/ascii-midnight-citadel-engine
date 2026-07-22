class_name ASCIIGridRenderer
extends Control
## Pixel-Perfect Crisp ASCII Grid Renderer.
## Renders cell glyphs and colors onto a discrete pixel grid with nearest-neighbor filtering.

@export var grid_width: int = 80
@export var grid_height: int = 45
@export var cell_size: Vector2i = Vector2i(16, 16)
@export var font: Font

var buffer: ASCIIGridBuffer


func _init() -> void:
	texture_filter = TEXTURE_FILTER_NEAREST


func _ready() -> void:
	texture_filter = TEXTURE_FILTER_NEAREST
	buffer = ASCIIGridBuffer.new(grid_width, grid_height)
	custom_minimum_size = Vector2(grid_width * cell_size.x, grid_height * cell_size.y)


func _draw() -> void:
	if not buffer:
		return

	var active_font: Font = font
	if not active_font:
		active_font = ThemeDB.fallback_font

	var font_size: int = cell_size.y

	for y in range(grid_height):
		for x in range(grid_width):
			var cell_rect: Rect2 = Rect2(
				Vector2(x * cell_size.x, y * cell_size.y), Vector2(cell_size)
			)

			var bg_color: Color = buffer.get_cell_bg(x, y)
			draw_rect(cell_rect, bg_color, true)

			var char_str: String = buffer.get_cell_char(x, y)
			if char_str != " ":
				var fg_color: Color = buffer.get_cell_fg(x, y)
				var text_pos: Vector2 = Vector2(x * cell_size.x, (y + 1) * cell_size.y - 2)
				draw_string(
					active_font,
					text_pos,
					char_str,
					HORIZONTAL_ALIGNMENT_CENTER,
					cell_size.x,
					font_size,
					fg_color
				)
