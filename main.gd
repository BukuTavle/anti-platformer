extends Node2D

var player_health: int = 3
var DeadPlayerBody: PackedScene
var dead_player_body_instanced: Node
signal player_damaged
signal player_dead

# Called when the node enters the scene tree for the first time.
func damage_player() -> void:
	if not player_health <= 0 and !$Player.is_damaged:
		player_health -= 1
		player_damaged.emit()
		if player_health <= 0:
			game_over()

func _ready() -> void:
	DisplayServer.window_set_size(Vector2i(1440, 1080)) #Project settings -> display -> window -> window mode -> maximised if not embedded
	DeadPlayerBody = preload("res://dead_player_body.tscn")
	dead_player_body_instanced = DeadPlayerBody.instantiate()
	_on_game_restarted()
func start_level(level: int) -> void:
	pass

func game_over() -> void:
	player_dead.emit()
	#print("død1")
	$HUD.show_game_over()
	await $Player.died
	#print("død2")
	add_child(dead_player_body_instanced)
	dead_player_body_instanced.position = $Player.position 
	$Player.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_position: Vector2
	player_position = $Player.get_position()
	
	$Camera2D.position.x = player_position.x
	#$Camera2D.position = $Camera2D.position.clamp(Vector2(128, 1000), Vector2(1000, -1000) )
	
func _on_green_slime_damage_player() -> void:
	#print("dead")
	damage_player()
	


func _on_game_restarted() -> void:
	player_health = 3
	$Player.position = $"../PlayerSpawnPoint".position
	$Player.show()
