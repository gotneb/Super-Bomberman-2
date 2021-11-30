extends KinematicBody2D
class_name Player

export var speed := 25
var stage: Node2D

var _velocity := Vector2.ZERO


func _process(delta) -> void:
	_move(delta)


func _move(delta: float) -> void:
	_velocity = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
	_select_animation()
	
	if Input.is_action_just_pressed("put_bomb"):
		_put_bomb()
	
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


func _put_bomb() -> void:
	$BombPutted.play(0.67)
	var bomb: Bomb = preload("res://scenes/world/bombs/bomb.tscn").instance()
	var x:= (int(position.x) / 16) * 16 + 8
	var y:= (int(position.y) / 16) * 16 + 3
	bomb.position = Vector2(x, y)
	stage.get_node("Bombs").add_child(bomb)
