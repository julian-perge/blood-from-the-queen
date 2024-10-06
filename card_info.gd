extends Node2D

class_name CardInfo

var info: Dictionary
var card_name: String
var rank: String
var power: int
var has_ability: bool
var ability: String
var number: int
var rarity: String
var placement: Array
var texture: Texture2D

func _init(data: Dictionary):
	info = data
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
