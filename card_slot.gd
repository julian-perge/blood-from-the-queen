extends ColorRect

class_name CardSlot

var HIGHLIGHT_COLOR = Color(0.75, 0.5, 0, 0.5)
var pawns: Label

@export var card_in_slot: Card
@export var highlight_obj: ColorRect
@export var player_pawn_counter: int = 0
@export var enemy_pawn_counter: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pawns = $Pawns
	highlight_obj = ColorRect.new()
	highlight_obj.name = "SlotHighlight"
	highlight_obj.visible = false
	highlight_obj.color = HIGHLIGHT_COLOR
	highlight_obj.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(highlight_obj)

func set_card(card: Card) -> void:
	card_in_slot = card
	card.reparent(self, false)
	card.set_position(Vector2.ZERO)
	card.set_selected(false)
	card.set_anchors_preset(Control.PRESET_FULL_RECT)

func highlight():
	highlight_obj.visible = true

func unhighlight():
	highlight_obj.visible = false

func increase_pawn(is_player: bool = true, count: int = 1) -> void:
	if is_player:
		player_pawn_counter = min(player_pawn_counter + count, 3)
		pawns.text = str(player_pawn_counter)
	else:
		enemy_pawn_counter = min(enemy_pawn_counter + count, 3)
		pawns.text = str(enemy_pawn_counter)

func decrease_pawn(is_player: bool = true, count: int = 1) -> void:
	print("Decreasing %s pawn count for %s" % ["player" if is_player else "enemy", name])
	if is_player:
		player_pawn_counter -= count
		pawns.text = str(player_pawn_counter)
	else:
		enemy_pawn_counter -= count
		pawns.text = str(enemy_pawn_counter)
