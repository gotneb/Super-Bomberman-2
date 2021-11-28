extends KinematicBody2D
class_name Player

export var speed := 25
var _velocity := Vector2.ZERO

func _physics_process(delta) -> void:
	_move(delta)


func _move(delta: float) -> void:
	_velocity = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
	_select_animation()
	_velocity = move_and_slide(_velocity * speed * delta * 100)


func _select_animation() -> void:
	# Player is still movimenting
	if _velocity.x == -1:
		$AnimatedSprite.play("left")
	elif _velocity.x == 1:
		$AnimatedSprite.play("right")
	elif _velocity.y == 1:
		$AnimatedSprite.play("down")
	elif _velocity.y == -1:
		$AnimatedSprite.play("top")
	# Stopped
	else:
		$AnimatedSprite.frame = 1
		$AnimatedSprite.stop()
