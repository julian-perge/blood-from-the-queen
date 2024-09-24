extends Area2D

class_name Card

var card_name: String
var rank: String
var power: int
var has_ability: bool
var ability: String
var number: int
var rarity: String
var texture: Texture2D

var dragging = false
var drag_offset = Vector2.ZERO
var original_position = Vector2.ZERO
var scale_factor = Vector2(1.25, 1.25)  # Adjust scale as needed

func _init(data: Dictionary):
	# print(data)
	card_name = data["name"]
	rank = data["rank"]
	power = data["power"]
	has_ability = data["hasAbility"]
	ability = data["ability"]
	number = data["number"]
	rarity = data["rarity"]
	
	# Load the card texture
	texture = load(data["image"])

func _ready():
	# Create a sprite to display the card
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.scale = scale_factor
		
	add_child(sprite)
	
	# Add labels for rank and power
	#var rank_label = Label.new()
	#rank_label.text = rank
	#rank_label.position = Vector2(10, 10)  # Adjust position as needed
	#add_child(rank_label)
	#
	#var power_label = Label.new()
	#power_label.text = str(power)
	#power_label.position = Vector2(90, 10)  # Adjust position as needed
	#add_child(power_label)

	# Set up collision shape for Area2D
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	var extents = sprite.texture.get_size() * sprite.scale / 2
	shape.extents = extents
	collision_shape.shape = shape
	add_child(collision_shape)
	
	original_position = position

func get_card_width():
	return texture.get_width() * scale_factor.x

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_offset = position - get_global_mouse_position()
				get_parent().move_child(self, get_parent().get_child_count() - 1)  # Bring to front
				var board = get_tree().get_root().get_node("GameManager/Board")
				board.highlight_valid_placements(self)
			else:
				dragging = false
				var board = get_tree().get_root().get_node("GameManager/Board")
				var cell = board.get_cell_at_position(get_global_mouse_position())
				if board.place_card(self, cell):
					get_parent().remove_child(self)
					board.add_child(self)
				else:
					position = original_position
				board.clear_highlights()

func _process(delta):
	if dragging:
		position = get_global_mouse_position() + drag_offset
