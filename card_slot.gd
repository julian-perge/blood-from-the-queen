extends ColorRect

class_name CardSlot

var pawns: Label
@export var player_pawn_counter: int = 0
@export var enemy_pawn_counter: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pawns = $Pawns
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func increase_pawn(is_player: bool = true, count: int = 1) -> void:
	print("Increasing %s pawn count for %s" % ["player" if is_player else "enemy", name])
	if is_player:
		player_pawn_counter += count
		pawns.text = str(player_pawn_counter)
	else:
		enemy_pawn_counter += count
		pawns.text = str(enemy_pawn_counter)

func decrease_pawn(is_player: bool = true, count: int = 1) -> void:
	print("Decreasing %s pawn count for %s" % ["player" if is_player else "enemy", name])
	if is_player:
		player_pawn_counter -= count
		pawns.text = str(player_pawn_counter)
	else:
		enemy_pawn_counter -= count
		pawns.text = str(enemy_pawn_counter)
