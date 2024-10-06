extends Node2D

class_name CardManager

var cards = {}
var cards_by_rank = {}
var card_counts = {}
const MAX_COPIES = 2

func _ready():
	name = "CardManager"
	load_all_cards()
	organize_cards_by_rank()

func load_all_cards():
	var dir = DirAccess.open("res://cards/json")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json"):
				var card_data = load_card_data(file_name)
				var card_info = CardInfo.new(card_data)
				cards[card_info.number] = card_info
				card_counts[card_info.number] = 0  # Initialize count to 0
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the card data directory.")

func load_card_data(file_name: String) -> Dictionary:
	var json_file = "res://cards/json/" + file_name
	#print("Loading file %s" % [json_file])
	var file = FileAccess.open(json_file, FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	if error == OK:
		return json.get_data()
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", file_name, " at line ", json.get_error_line())
		return {}

func organize_cards_by_rank() -> void:
	cards_by_rank.clear()
	for card in cards.values():
		var rank = card.rank
		if rank not in cards_by_rank:
			cards_by_rank[rank] = []
		cards_by_rank[rank].append(card)

func get_cards_of_rank(rank: String) -> Array:
	return cards_by_rank.get(rank, [])

func add_card_to_deck(card_number: int) -> bool:
	if card_number in cards and card_counts[card_number] < MAX_COPIES:
		card_counts[card_number] += 1
		return true
	return false

func remove_card_from_deck(card_number: int) -> bool:
	if card_number in cards and card_counts[card_number] > 0:
		card_counts[card_number] -= 1
		return true
	return false

func get_card_count(card_number: int) -> int:
	return card_counts.get(card_number, 0)

func get_available_cards() -> Array:
	var available_cards = []
	for card_number in cards.keys():
		if card_counts[card_number] < MAX_COPIES:
			available_cards.append(cards[card_number])
	return available_cards

func get_random_card(rank: int = -1) -> Card:
	var available_cards = get_available_cards()
	if rank > 0:
		available_cards = available_cards.filter(func(card): return int(card.rank) == rank)
	
	if available_cards.is_empty():
		print("No available cards" + (" of rank " + str(rank) if rank > 0 else ""))
		return null
	
	var random_card = available_cards[randi() % available_cards.size()]
	add_card_to_deck(random_card.number)
	return Card.new(random_card.info)
