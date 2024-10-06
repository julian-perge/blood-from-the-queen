extends VSplitContainer

class_name Hand

var CardsObj: BoxContainer
var CardAbilityLabel: Label
var cards = []
@export var selected_card: Card
@export var selected_card_index: int = 0

func _ready() -> void:
	CardsObj = $Cards
	CardAbilityLabel = $CardLabel

func add_card(card: Card):
	print("Adding card to hand -> %s" % card.to_string())
	cards.append(card)
	CardsObj.add_child(card)

func set_selected_card() -> void:
	for i in range(cards.size()):
		cards[i].set_selected(i == selected_card_index)
		selected_card = cards[selected_card_index]

func display_card_description(card: Card):
	print("Displaying card ability [%s] - [%s]" % [card.card_name, card.ability])
	CardAbilityLabel.text = card.ability
