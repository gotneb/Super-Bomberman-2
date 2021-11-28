extends KinematicBody2D
class_name Bomb


func _ready():
	$AnimatedSprite.play("default")
	$Timer.start()


# Start explosion
func _on_Timer_timeout():
	queue_free()


func _on_body_exited(body):
	$Colision.set_deferred("disabled", false)
