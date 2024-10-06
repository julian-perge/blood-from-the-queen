extends Node2D

class_name GameManager

var card_manager: CardManager
var hand: Hand
var game_board: Board
var placement_mode: bool = false
var current_lane: int = 0
var current_slot: int = 0

func _ready():
	card_manager = CardManager.new()
	add_child(card_manager)
	# The hand is a child of the GameManager object, so we can use $ syntax to grab it
	hand = $PlayerHand
	game_board = $Board

	# For testing, add some cards to the hand
	add_random_cards_to_hand()
	
	# Set to the first card
	update_card_selection()

# Example usage in _ready or another function:
func add_random_cards_to_hand(count: int = 5) -> void:
	for i in range(count):
		var random_rank = 1  # Random rank between 1 and 3
		var random_card = card_manager.get_random_card(random_rank)
		if random_card:
			hand.add_card(random_card)
		else:
			print("Failed to add random card of rank ", random_rank)

func _input(event):
	if placement_mode:
		handle_placement_input(event)
	else:
		handle_selection_input(event)

func handle_selection_input(event):
	if event.is_action_pressed("ui_left"):
		select_previous_card()
	elif event.is_action_pressed("ui_right"):
		select_next_card()
	elif event.is_action_pressed("ui_accept"):
		enter_placement_mode()

func handle_placement_input(event):
	if event.is_action_pressed("ui_left"):
		move_placement_left()
	elif event.is_action_pressed("ui_right"):
		move_placement_right()
	elif event.is_action_pressed("ui_up"):
		move_placement_up()
	elif event.is_action_pressed("ui_down"):
		move_placement_down()
	elif event.is_action_pressed("ui_accept"):
		confirm_placement()
	elif event.is_action_pressed("ui_cancel"):
		exit_placement_mode()

func enter_placement_mode():
	placement_mode = true
	var card = hand.selected_card
	game_board.show_placement_preview(card)
	find_initial_valid_slot()

func find_initial_valid_slot():
	for lane in range(3):
		for slot in range(5):
			if game_board.lanes[lane].can_place_card(hand.selected_card, slot):
				current_lane = lane
				current_slot = slot
				game_board.update_preview_position(current_lane, current_slot)
				return
	print("No valid placement found for the selected card.")
	exit_placement_mode()

func exit_placement_mode():
	placement_mode = false
	game_board.clear_placement_preview()
	game_board.clear_highlights()

func move_placement_left():
	var original_lane = current_lane
	var original_slot = current_slot
	while true:
		current_slot -= 1
		if current_slot < 0:
			current_lane = (current_lane - 1 + 3) % 3
			current_slot = 4
		if game_board.lanes[current_lane].can_place_card(hand.selected_card, current_slot):
			game_board.update_preview_position(current_lane, current_slot)
			return
		if current_lane == original_lane and current_slot == original_slot:
			return  # We've checked all positions

func move_placement_right():
	var original_lane = current_lane
	var original_slot = current_slot
	while true:
		current_slot += 1
		if current_slot > 4:
			current_lane = (current_lane + 1) % 3
			current_slot = 0
		if game_board.lanes[current_lane].can_place_card(hand.selected_card, current_slot):
			game_board.update_preview_position(current_lane, current_slot)
			return
		if current_lane == original_lane and current_slot == original_slot:
			return  # We've checked all positions

func move_placement_up():
	var original_lane = current_lane
	var original_slot = current_slot
	while true:
		current_lane = (current_lane - 1 + 3) % 3  # Move up, wrapping around
		if game_board.lanes[current_lane].can_place_card(hand.selected_card, current_slot):
			game_board.update_preview_position(current_lane, current_slot)
			return
		if current_lane == original_lane:
			# We've checked all lanes in this column, try the next valid column
			return move_placement_left()

func move_placement_down():
	var original_lane = current_lane
	var original_slot = current_slot
	while true:
		current_lane = (current_lane + 1) % 3  # Move down, wrapping around
		if game_board.lanes[current_lane].can_place_card(hand.selected_card, current_slot):
			game_board.update_preview_position(current_lane, current_slot)
			return
		if current_lane == original_lane:
			# We've checked all lanes in this column, try the next valid column
			return move_placement_right()

func confirm_placement():
	var card = hand.selected_card
	var lane = game_board.lanes[current_lane]
	var slot = game_board.lanes[current_lane].card_slots[current_slot]
	if game_board.can_place_card(card, current_lane, current_slot):
		var removed_card = hand.remove_card(hand.selected_card_index)
		print("Placing card %s in lane %s slot %s" % [removed_card.card_name, current_lane, current_slot])
		slot.set_card(removed_card)
		lane.update_score(card.power)
		lane.update_pawns(card, current_lane, current_slot)
		exit_placement_mode()
		update_card_selection()
	else:
		print("Invalid placement")

func select_next_card():
	if hand.cards.size() > 0:
		hand.selected_card_index = (hand.selected_card_index + 1) % hand.cards.size()
		update_card_selection()

func select_previous_card():
	if hand.cards.size() > 0:
		hand.selected_card_index = (hand.selected_card_index - 1 + hand.cards.size()) % hand.cards.size()
		update_card_selection()

func update_card_selection():
	#print("Updating card selection with index: %s" % hand.selected_card_index)
	hand.set_selected_card()
	
	hand.display_card_description(hand.selected_card)
