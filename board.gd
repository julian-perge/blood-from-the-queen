extends BoxContainer

class_name Board

var lane1: Lane
var lane2: Lane
var lane3: Lane

@export var score_labels: Node2D

func _ready() -> void:
	lane1 = $Lane1
	lane2 = $Lane2
	lane3 = $Lane3

func place_card(card_slot) -> bool:
	#if lane.can_place_card(card):
		#card.get_parent().remove_child(card)
		#update_score(card)
		#add_new_pawns(card)
	return true

func update_score(card: Card):
	pass

func add_new_pawns(card: Card):
	# TODO: Implement pawn addition logic based on card's position tiles
	print("Adding new pawns")

func highlight_valid_placements(card: Card):
	clear_highlights()
	print("Highlighting valid placements")
	for lane in [lane1, lane2, lane3]:
		#if lane.can_place_card(card):
		lane.highlight_slot(card)

func clear_highlights():
	print("Clearing highlights")
	pass
