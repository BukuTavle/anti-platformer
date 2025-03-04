extends CharacterBody2D

signal damage_player
var speed: float = 75.0
var dead: bool = false

func _ready() -> void:
	velocity.x = speed
	$AnimationPlayer.play("walk")
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
	if is_on_wall():
		velocity.x = speed
		speed *= -1
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	else: 
		$Sprite2D.flip_h = false
	
	#for i in get_slide_collision_count():
		#var collision = get_slide_collision(i)
		#if collision.get_collider().name == "Player" and $"../Player".is_rolling == false:
			#damage_player.emit()
			#print("dead")
		#elif collision.get_collider().name == "Player" and $"../Player".is_rolling and !dead:
			#dead = true
			#$DeathTimer.start()
			#$AnimationPlayer.play("death") 
			#velocity.x = 0
			#speed = 0
	


func _on_death_timer_timeout() -> void:
	queue_free()





func _on_area_2d_body_entered(body: Node2D) -> void:
	if !$"../../Main/Player".is_rolling:
		damage_player.emit()
		#print("dead")
		
	elif $"../../Main/Player".is_rolling:
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$DeathTimer.start()
		$AnimationPlayer.play("death")
		velocity.x = 0
		speed = 0
