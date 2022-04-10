extends KinematicBody2D
class_name Bomb

var _hasExploded := false
var power: int
var player

func _ready():
	$AnimatedSprite.play("default")
	$Timer.start()


# Start explosion
func _on_Timer_timeout():
	#queue_free()
	_hasExploded = true
	$AnimatedSprite.visible = false
	$Colision.set_deferred("disabled", true)
	_create_explosion()


func _create_explosion() -> void:
	var explosion: Explosion = preload("res://scenes/world/bombs/explosion.tscn").instance()
	explosion.position = Vector2(0, -7)
	explosion.bomb = self
	explosion.power = power
	$Explosion.add_child(explosion)
	player.bombs += 1


func _on_body_exited(body):
	if not _hasExploded:
		$Colision.set_deferred("disabled", false)
		body.is_inside_bomb = false
