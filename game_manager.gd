extends Node2D

class_name GameManager

var card_manager: CardManager
var hand: Hand
var game_board: Board

func _ready():
	card_manager = CardManager.new()
	add_child(card_manager)
	# The hand is a child of the GameManager object, so we can use $ syntax to grab it
	hand = $PlayerHand
	game_board = $Board

	# For testing, add some cards to the hand
	for i in range(5):
		var random_card = card_manager.cards.values()[randi() % card_manager.cards.size()]
		hand.add_card(random_card)
	# Set to the first card
	update_card_selection()

func _input(event):
	if event.is_action_pressed("ui_left"):
		select_previous_card()
	elif event.is_action_pressed("ui_right"):
		select_next_card()
	elif event.is_action_pressed("ui_accept"):
		place_selected_card()

func select_next_card():
	if hand.cards.size() > 0:
		hand.selected_card_index = (hand.selected_card_index + 1) % hand.cards.size()
		update_card_selection()

func select_previous_card():
	if hand.cards.size() > 0:
		hand.selected_card_index = (hand.selected_card_index - 1 + hand.cards.size()) % hand.cards.size()
		update_card_selection()

func update_card_selection():
	print("Updating card selection with index: %s" % hand.selected_card_index)
	hand.set_selected_card()
	
	hand.display_card_description(hand.selected_card)
	game_board.highlight_valid_placements(hand.cards[hand.selected_card_index])

func place_selected_card():
	# Once the player hits enter, toggle visible cursor on current card off
	# Then, highlight board with a cursor on only visible slots, selectable slots
	# Once card is placed, update hand and reset index back to 1
	print("No valid placement found for the selected card.")
