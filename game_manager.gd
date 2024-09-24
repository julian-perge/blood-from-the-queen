extends Node2D

const COLS = 7
const ROWS = 3

var card_manager
var hand
var board

func _ready():
	var screen_size = get_viewport_rect().size
	
	board = Board.new()
	add_child(board)
	
	card_manager = CardManager.new()
	add_child(card_manager)
	
	hand = Hand.new()
	hand.name = "PlayerHand"
	hand.position = Vector2(0, screen_size.y - 150)  # Adjust 150 based on your card size
	add_child(hand)

	# For testing, add some cards to the hand
	for i in range(5):
		var random_card = card_manager.cards.values()[randi() % card_manager.cards.size()]
		print("Adding card to hand %s" % random_card.card_name)
		hand.add_card(random_card)
		
	# Position the hand after adding cards
	var card_height = hand.cards[0].texture.get_height() * hand.cards[0].scale_factor.y if hand.cards.size() > 0 else 150
	hand.position = Vector2(0, screen_size.y - card_height + 100)

	# Ensure the hand is centered horizontally
	hand.rearrange_cards()
	
	create_score_labels()

func create_score_labels():
	board.score_labels = Node2D.new()
	board.score_labels.name = "ScoreLabels"
	
	for i in range(ROWS):
		var player_label = Label.new()
		player_label.name = "Player" + str(i)
		player_label.text = "0"
		player_label.position = Vector2(0, (i + 0.5) * board.CELL_SIZE)
		board.score_labels.add_child(player_label)
		
		var enemy_label = Label.new()
		enemy_label.name = "Enemy" + str(i)
		enemy_label.text = "0"
		enemy_label.position = Vector2((COLS - 1) * board.CELL_SIZE, (i + 0.5) * board.CELL_SIZE)
		board.score_labels.add_child(enemy_label)
