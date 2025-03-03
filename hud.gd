extends CanvasLayer

func show_message(text) -> void:
	$Message.text = text
	$Message.show()
	
func show_game_over() -> void:
	show_message("Game Over")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass
	push_error("Fiks health, nå!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"../Player".health == 3:
		$Health/AnimationPlayer.play("full_health")
	elif $"../Player".health == 2:
		$Health/AnimationPlayer.play("two_health")
	elif $"../Player".health == 1:
		$Health/AnimationPlayer.play("one_health")
