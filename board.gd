extends BoxContainer

class_name Board

@export var current_lane: int = 0
@export var current_slot: int = 0

@export var lane1: Lane
@export var lane2: Lane
@export var lane3: Lane
@export var lanes: Array[Lane]
var preview_card: Sprite2D

@export var score_labels: Node2D

func _ready() -> void:
	lane1 = $Lane1
	lane2 = $Lane2
	lane3 = $Lane3
	lanes = [lane1, lane2, lane3]

func show_placement_preview(card: Card):
	preview_card = card.sprite.duplicate()
	preview_card.name += "_preview"
	preview_card.modulate.a = 0.5  # Make it semi-transparent
	add_child(preview_card)
	highlight_valid_slots(card)

func clear_placement_preview():
	if preview_card:
		remove_child(preview_card)
		preview_card.queue_free()
		preview_card = null
	clear_highlights()

func highlight_valid_slots(card: Card):
	clear_highlights()
	for lane in lanes:
		lane.highlight_valid_slots(card)

func highlight_current_slot(lane: int, slot: int):
	lanes[lane].highlight_slot(slot)

func update_preview_position(lane: int, slot: int):
	if preview_card:
		var slot_node = lanes[lane].card_slots[slot]
		preview_card.global_position = slot_node.global_position
	highlight_current_slot(lane, slot)

func can_place_card(card: Card, lane: int, slot: int) -> bool:
	return lanes[lane].can_place_card(card, slot)

func clear_highlights():
	for lane in lanes:
		lane.clear_highlights()
