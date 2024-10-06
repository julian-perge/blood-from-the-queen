extends Node2D

class_name CardManager

var cards = {}

func _ready():
	name = "CardManager"
	load_all_cards()

func load_all_cards():
	var dir = DirAccess.open("res://cards/json")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json"):
				var card_data = load_card_data(file_name)
				var card = Card.new(card_data)
				cards[card.number] = card
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the card data directory.")

func load_card_data(file_name: String):
	var json_file = "res://cards/json/" + file_name
	var file = FileAccess.open(json_file, FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	if error == OK:
		return json.get_data()
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", file_name, " at line ", json.get_error_line())
		return null
