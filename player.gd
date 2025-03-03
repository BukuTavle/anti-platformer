extends CharacterBody2D

var screen_size: Vector2 = Vector2.ZERO
var is_rolling: bool
var health: int = 3
const SPEED: float = 150.0
const JUMP_VELOCITY: float = -250.0
const ROLL_VELOCITY: float = 250.0
signal dead

func _ready() -> void:
	screen_size = get_viewport_rect().size
	$NormalHitbox.disabled = false
	$RollingHitbox.disabled = true
	position = $"../../PlayerSpawnPoint".position
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.x < 0 and $AnimationPlayer.current_animation != "roll":
		$AnimationPlayer.play("walk")
		$Sprite2D.flip_h = true
	elif velocity.x > 0 and $AnimationPlayer.current_animation != "roll":
		$AnimationPlayer.play("walk")
		$Sprite2D.flip_h = false
	elif $AnimationPlayer.current_animation != "roll":
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


func _on_roll_timer_timeout() -> void:
	$RollingHitbox.disabled = true
	$NormalHitbox.disabled = false
	is_rolling = false
	


func _on_green_slime_damage_player() -> void:
	health -= 1
	if health <= 0:
		dead.emit()
