extends Node2D

class_name Board

# Constants for board dimensions
const COLS = 7
const ROWS = 3
var CELL_SIZE = 100  # We'll calculate this based on screen size

var grid = []
var placement_highlights = []

@export var score_labels: Node2D

func _ready():
	calculate_cell_size()
	create_board()
	create_placement_highlights()
	name = "Board"

func calculate_cell_size() -> void:
	var screen_size = get_viewport_rect().size
	CELL_SIZE = screen_size.x / (COLS + 1)  # +1 to leave some margin

func create_board() -> void:
	for col in range(COLS):
		grid.append([])
		for row in range(ROWS):
			var cell = create_cell(col, row)
			grid[col].append(cell)
			add_child(cell)

func create_cell(col, row) -> ColorRect:
	var cell = ColorRect.new()
	cell.name = "cell_col_%s_row_%s" % [col, row]
	cell.size = Vector2(CELL_SIZE, CELL_SIZE)
	cell.position = Vector2(col * CELL_SIZE, row * CELL_SIZE)
	
	if col == 0 or col == COLS - 1:
		cell.color = Color(0.2, 0.2, 0.2)
	else:
		cell.color = Color(0.5, 0.5, 0.5)
	
	var border = Line2D.new()
	border.points = [Vector2(0, 0), Vector2(CELL_SIZE, 0), Vector2(CELL_SIZE, CELL_SIZE), Vector2(0, CELL_SIZE), Vector2(0, 0)]
	border.width = 2
	border.default_color = Color.BLACK
	cell.add_child(border)
	
	return cell

func create_placement_highlights() -> void:
	for col in range(1, COLS - 1):  # Exclude score columns
		for row in range(ROWS):
			var highlight = ColorRect.new()
			highlight.name = "high_col_%s_row_%s" % [col, row]
			highlight.size = Vector2(CELL_SIZE, CELL_SIZE)
			highlight.position = Vector2(col * CELL_SIZE, row * CELL_SIZE)
			highlight.color = Color(0, 1, 0, 0.3)  # Semi-transparent green
			highlight.visible = false
			add_child(highlight)
			placement_highlights.append(highlight)

func get_cell_at_position(position: Vector2) -> Vector2:
	var col = int(position.x / CELL_SIZE)
	var row = int(position.y / CELL_SIZE)
	if col >= 1 and col <= 5 and row >= 0 and row < ROWS:
		return Vector2(col, row)
	return Vector2(-1, -1)

func can_place_card(cell: Vector2, card: Card) -> bool:
	# Check if the cell is in the playable area
	if cell.x < 1 or cell.x > 5 or cell.y < 0 or cell.y >= ROWS:
		return false
	
	# Check if the cell is empty
	var grid_childs: int = grid[cell.x][cell.y].get_child_count()
	print("Grid child count is %s" % grid_childs)
	if grid_childs > 1:  # 1 because of the border
		return false
	
	# TODO: Add more placement rules here (e.g., rank checks)
	
	return true

func place_card(card: Card, cell: Vector2) -> bool:
	if can_place_card(cell, card):
		print("Cell x %s y %s" % [cell.x, cell.y])
		var new_x = cell.x * CELL_SIZE
		var new_y = clampf(cell.y, 1.0, ROWS) * CELL_SIZE * 0.5
		print("Card can be placed, x %s y %s" % [new_x, new_y])
		var target_position = Vector2(new_x, new_y)
		card.position = target_position
		card.get_parent().remove_child(card)
		grid[cell.x][cell.y].add_child(card)
		update_score(card, cell)
		add_new_pawns(card, cell)
		return true
	return false

func update_score(card: Card, cell: Vector2):
	var score_label = score_labels.get_node("Player" + str(cell.y))
	var current_score = int(score_label.text)
	current_score += card.power
	score_label.text = str(current_score)

func add_new_pawns(card: Card, cell: Vector2):
	# TODO: Implement pawn addition logic based on card's position tiles
	print("Adding new pawns")

func highlight_valid_placements(card: Card):
	for col in range(1, COLS - 1):
		for row in range(ROWS):
			var cell = Vector2(col, row)
			var index = (col - 1) * ROWS + row
			placement_highlights[index].visible = can_place_card(cell, card)

func clear_highlights():
	for highlight in placement_highlights:
		highlight.visible = false
