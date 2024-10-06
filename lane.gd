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

func highlight_valid_slots(card: Card):
	for i in range(card_slots.size()):
		if can_place_card(card, i):
			card_slots[i].highlight()
		else:
			card_slots[i].unhighlight()

func highlight_slot(slot_index: int):
	for i in range(card_slots.size()):
		if i == slot_index:
			card_slots[i].highlight()
		else:
			card_slots[i].unhighlight()

func can_place_card(card: Card, slot_index: int) -> bool:
	var slot = card_slots[slot_index]
	var rank = int(card.rank) if card.rank != "Replace" else 1
	return slot.card_in_slot == null and slot.player_pawn_counter >= rank

func clear_highlights():
	for slot in card_slots:
		slot.unhighlight()

func place_card(card: Card, slot_index: int) -> bool:
	return can_place_card(card, slot_index)

func update_score(power: int):
	player_score += power
	player_score_label.text = str(player_score)

func update_pawns(card: Card, lane_index: int, slot_index: int):
	var board = get_parent()
	for offset in card.get_affected_tiles():
		var target_slot = slot_index + offset.x
		var target_lane_index = lane_index + offset.y
		
		# Check if the target is within the board bounds
		if 0 <= target_slot and target_slot < 5 and 0 <= target_lane_index and target_lane_index < 3:
			var target_lane = board.lanes[target_lane_index]
			var target_card_slot = target_lane.card_slots[target_slot]
			var current_pawns = target_card_slot.player_pawn_counter
			target_card_slot.increase_pawn(true, min(3 - current_pawns, 1))

func get_lane_index() -> int:
	return get_parent().lanes.find(self)
