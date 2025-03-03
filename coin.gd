extends Area2D

signal picked_up
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("spin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node2D) -> void:
	picked_up.emit()
	queue_free()
