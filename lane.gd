extends GridContainer

class_name Lane

var player_score_label: Label
var player_score: int = 0

var enemy_score_label: Label
var enemy_score: int = 0

var card_slot_1: CardSlot
var card_slot_2: CardSlot
var card_slot_3: CardSlot
var card_slot_4: CardSlot
var card_slot_5: CardSlot

var card_slots = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_score_label = $PlayerScore.get_child(0)
	player_score_label.text = str(player_score)
	
	enemy_score_label = $EnemyScore.get_child(0)
	enemy_score_label.text = str(enemy_score)
	
	card_slot_1 = $CardSlot1
	card_slot_1.increase_pawn()
	
	card_slot_2 = $CardSlot2
	card_slot_3 = $CardSlot3
	card_slot_4 = $CardSlot4
	
	card_slot_5 = $CardSlot5
	card_slot_5.increase_pawn(false)

	card_slots = [card_slot_1, card_slot_2, card_slot_3, card_slot_4, card_slot_5]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func can_place_card(card: Card) -> bool:
	# Check if the cell is in the playable area
	# TODO: Add more placement rules here (e.g., rank checks)
	return false

func highlight_slot(card: Card) -> void:
	for slot in card_slots:
		if slot.player_pawn_counter > 0:
			print("Highlighting lane %s slot %s" % [name, slot.name])
			slot.color = Color.YELLOW_GREEN
