extends Node2D

var player_health: int = 3
signal player_damaged
signal player_dead
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func start_game(level) -> void:
	pass

func game_over() -> void:
	$Player.hide()
	$HUD.show_game_over()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_position: Vector2
	player_position = $Player.get_position()
	
	$Camera2D.position.x = player_position.x
	#$Camera2D.position = $Camera2D.position.clamp(Vector2(128, 1000), Vector2(1000, -1000) )
	
func _on_green_slime_damage_player() -> void:
	#print("dead")
	player_health -= 1
	player_damaged.emit()
	if player_health <= 0:
		player_dead.emit()
