extends CharacterBody2D

var screen_size: Vector2 = Vector2.ZERO
var is_rolling: bool = false
var is_damaged: bool = false
var dead: bool = false
#var dead_body: RigidBody2D
const SPEED: float = 150.0
const JUMP_VELOCITY: float = -250.0
const ROLL_VELOCITY: float = 250.0
signal died
signal game_started

func start_game():
	print("Player: start_game")
	$NormalHitbox.disabled = false
	$RollingHitbox.disabled = true #probably not needed, but just in case, you know
	$StartTimer.start()
	game_started.emit()
	

func _ready() -> void:
	screen_size = get_viewport_rect().size
	start_game()
	#position = $"../../PlayerSpawnPoint".position
	#dead_body = $"..".get_node("DeadPlayerBody")
	
func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		


	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !is_damaged:
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction and !is_damaged:
		velocity.x = direction * SPEED
	elif !is_damaged:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.x < 0 and $AnimationPlayer.current_animation != "roll" and !is_damaged:
		$AnimationPlayer.play("walk")
		$Sprite2D.flip_h = true
	elif velocity.x > 0 and $AnimationPlayer.current_animation != "roll" and !is_damaged:
		$AnimationPlayer.play("walk")
		$Sprite2D.flip_h = false
	elif $AnimationPlayer.current_animation != "roll" and !is_damaged:
		$AnimationPlayer.play("idle")
	
	#Handle rolling
	if Input.is_action_just_pressed("roll") and is_on_floor():
		$RollTimer.start()
		is_rolling = true
		$AnimationPlayer.play("roll")
		$RollingHitbox.disabled = false
		$NormalHitbox.disabled = true
	
	if is_rolling == true:
		if $Sprite2D.flip_h:
			velocity.x = -ROLL_VELOCITY
		else:
			velocity.x = ROLL_VELOCITY
	
	
	
	move_and_slide()
	
	if dead: 
		await game_started
		#print("Player: process function died")


func _on_roll_timer_timeout() -> void:
	$RollingHitbox.disabled = true
	$NormalHitbox.disabled = false
	is_rolling = false
	


func _on_player_damaged() -> void:
	$AnimationPlayer.play("damaged")
	$DamageTimer.start()
	is_damaged = true
	$RollTimer.stop()


func _on_damage_timer_timeout() -> void:
	is_damaged = false


func _on_player_dead() -> void:
	$AnimationPlayer.play("dead")
	$DeathTimer.start()
	dead = true
	#$"..".add_child(dead_body)
	


func _on_death_timer_timeout() -> void:
	#$NormalHitbox.disabled = true
	#$RollingHitbox.disabled = true
	died.emit()


func _on_start_timer_timeout() -> void:
	dead = false
	#pass
