extends CanvasLayer

func show_message(text) -> void:
	$Message.text = text
	$Message.show()
	
func show_game_over() -> void:
	show_message("Game Over")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Health/AnimationPlayer.play("full_health")
	#push_error("Common parent er null eller noe sånt. Lag også animasjoner for alle healthene. ikke bare blink når du mister det siste. Kanskje gjør noe ekst")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_main_player_dead() -> void:
	$Health/AnimationPlayer.play("dead")


func _on_main_player_damaged() -> void:
	print($"..".player_health)
	if $"..".player_health == 3:
		$Health/AnimationPlayer.play("full_health")
	elif $"..".player_health == 2:
		$Health/AnimationPlayer.play("two_health")
	elif $"..".player_health == 1:
		$Health/AnimationPlayer.play("one_health")
