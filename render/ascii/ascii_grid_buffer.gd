class_name ASCIIGridBuffer
extends RefCounted
## Deterministic 2D Cell Buffer for Pixel-Perfect ASCII Rendering.
## Stores character glyphs, foreground colors, and background colors for grid coordinates.

var grid_width: int
var grid_height: int

## Flat arrays storing glyphs and color data per cell index (y * width + x).
var _glyphs: Array[String] = []
var _fg_colors: Array[Color] = []
var _bg_colors: Array[Color] = []


func _init(width: int = 80, height: int = 45) -> void:
	grid_width = max(1, width)
	grid_height = max(1, height)
	clear_buffer()


## Clear and resize buffer to default background/foreground colors and empty space glyphs.
func clear_buffer(
	default_char: String = " ", default_fg: Color = Color.WHITE, default_bg: Color = Color.BLACK
) -> void:
	var total_cells: int = grid_width * grid_height
	_glyphs.resize(total_cells)
	_fg_colors.resize(total_cells)
	_bg_colors.resize(total_cells)

	for i in range(total_cells):
		_glyphs[i] = default_char
		_fg_colors[i] = default_fg
		_bg_colors[i] = default_bg


## Get linear buffer index from grid (x, y) coordinates.
func _get_index(x: int, y: int) -> int:
	if x < 0 or x >= grid_width or y < 0 or y >= grid_height:
		return -1
	return y * grid_width + x


## Set cell glyph and color attributes.
func set_cell(
	x: int, y: int, char_str: String, fg: Color = Color.WHITE, bg: Color = Color.BLACK
) -> bool:
	var idx: int = _get_index(x, y)
	if idx == -1:
		return false

	_glyphs[idx] = char_str
	_fg_colors[idx] = fg
	_bg_colors[idx] = bg
	return true


## Retrieve cell glyph at coordinate.
func get_cell_char(x: int, y: int) -> String:
	var idx: int = _get_index(x, y)
	if idx == -1:
		return " "
	return _glyphs[idx]


## Retrieve cell foreground color at coordinate.
func get_cell_fg(x: int, y: int) -> Color:
	var idx: int = _get_index(x, y)
	if idx == -1:
		return Color.WHITE
	return _fg_colors[idx]


## Retrieve cell background color at coordinate.
func get_cell_bg(x: int, y: int) -> Color:
	var idx: int = _get_index(x, y)
	if idx == -1:
		return Color.BLACK
	return _bg_colors[idx]
