extends Control

class_name Card

var card_name: String
var rank: String
var power: int
var has_ability: bool
var ability: String
var number: int
var rarity: String
var placement: Array
var texture: Texture2D

var scale_factor = Vector2(0.35, 0.35)  # Cards are originally 768x1056
var selection_indicator: Control
var selected = false

func _init(data: Dictionary):
	card_name = data["name"]
	name = card_name
	rank = data["rank"]
	power = data["power"]
	has_ability = data["hasAbility"]
	ability = data["ability"]
	number = data["number"]
	rarity = data["rarity"]
	placement = data["placement"]
	
	# Load the card texture
	texture = load(data["image"])

func _to_string() -> String:
	return "Name: [%s] Rank: [%s] Power: [%s] Ability: [%s]" % [card_name, rank, power, ability]

func _ready():
	name = card_name
	# Makes it so that the card will expand the full horizontal length
	size_flags_horizontal = SizeFlags.SIZE_EXPAND_FILL
	# Create the card sprite
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.scale = scale_factor
	# Disable centering on the sprite so the card doesn't appear above the grid
	sprite.centered = false
	# Add the sprite as a child of the Card
	add_child(sprite)

	# Add a selection indicator (cursor.png)
	selection_indicator = Control.new()
	selection_indicator.set_anchors_preset(Control.PRESET_CENTER_TOP)
	selection_indicator.size_flags_horizontal = SizeFlags.SIZE_EXPAND_FILL
	selection_indicator.size_flags_vertical = SizeFlags.SIZE_EXPAND_FILL
	selection_indicator.name = "SelectionIndicator"
	selection_indicator.visible = false
	var selection_indicator_sprite = Sprite2D.new()
	selection_indicator_sprite.texture = load("res://cursor.png")
	selection_indicator.add_child(selection_indicator_sprite)
	
	# Now add the cursor control as child to the card sprite, this makes centering it easier
	sprite.add_child(selection_indicator)

func set_selected(is_selected: bool) -> void:
	if is_selected:
		print("Card %s is selected %s" % [name, is_selected])
	selected = is_selected
	selection_indicator.visible = selected
