extends GutTest

var _buffer: ASCIIGridBuffer


func before_each() -> void:
	_buffer = ASCIIGridBuffer.new(40, 25)


func test_buffer_initialization() -> void:
	assert_eq(_buffer.grid_width, 40, "Buffer width should match 40")
	assert_eq(_buffer.grid_height, 25, "Buffer height should match 25")
	assert_eq(_buffer.get_cell_char(0, 0), " ", "Default cell should be space")


func test_set_and_get_cell() -> void:
	var success: bool = _buffer.set_cell(5, 10, "@", Color.CYAN, Color.DARK_BLUE)
	assert_true(success, "set_cell inside bounds should return true")
	assert_eq(_buffer.get_cell_char(5, 10), "@", "Cell char should match '@'")
	assert_eq(_buffer.get_cell_fg(5, 10), Color.CYAN, "Cell FG should match CYAN")
	assert_eq(_buffer.get_cell_bg(5, 10), Color.DARK_BLUE, "Cell BG should match DARK_BLUE")


func test_out_of_bounds_cell() -> void:
	var success: bool = _buffer.set_cell(100, 100, "X")
	assert_false(success, "set_cell out of bounds should return false")
