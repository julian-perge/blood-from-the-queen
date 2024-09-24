extends Node2D

class_name Hand

var cards = []
var CARD_SPACING = 200  # We'll calculate this based on screen size and card count

func _ready():
	calculate_card_spacing()

func calculate_card_spacing():
	if cards.size() == 0:
		return
	var screen_size = get_viewport_rect().size
	var card_width = cards[0].get_card_width()
	var total_width = card_width * cards.size()
	
	if total_width <= screen_size.x:
		# If all cards fit, space them evenly
		CARD_SPACING = min((screen_size.x - total_width) / (cards.size() + 1) + card_width, card_width * 1.1)
	else:
		# If cards don't fit, allow overlap
		CARD_SPACING = (screen_size.x - card_width) / (cards.size() - 1)

func add_card(card: Card):
	cards.append(card)
	calculate_card_spacing()
	rearrange_cards()
	add_child(card)

func rearrange_cards():
	var screen_size = get_viewport_rect().size
	var total_width = CARD_SPACING * (cards.size() - 1) + cards[0].get_card_width()
	var start_x = (screen_size.x - total_width) / 2

	for i in range(cards.size()):
		var target_x = start_x + i * CARD_SPACING
		cards[i].position = Vector2(target_x, 0)

func return_card_to_hand(card: Card):
	if card in cards:
		calculate_card_spacing()
		rearrange_cards()
