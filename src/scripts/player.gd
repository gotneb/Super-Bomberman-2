extends KinematicBody2D
class_name Player

var speed := 25
var lifes := 2
var bombs := 1
var fire := 1
var stage: Node2D

var is_weak:= false
var is_inside_bomb := false

var _velocity := Vector2.ZERO


func _process(delta) -> void:
	if lifes >= 1:
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
	# Don't allow put bomb whether he doesn't have or then we've just putted one bomb 
	if bombs < 1 or is_inside_bomb:
		return
	
	# Setup player 
	is_inside_bomb = true
	$BombPutted.play(0.67)
	bombs -= 1
	# Make bomb
	var bomb: Bomb = preload("res://scenes/world/bombs/bomb.tscn").instance()
	bomb.player = self
	bomb.power = fire
	var x:= (int(position.x) / 16) * 16 + 8
	var y:= (int(position.y) / 16) * 16 + 3
	bomb.position = Vector2(x, y)
	stage.get_node("Bombs").add_child(bomb)


func take_damage() -> void:
	if is_weak:
		return

	lifes -= 1
	
	if lifes <= 0:
		$AnimatedSprite.play("death")
	else:
		is_weak = true
		$TakedDamage/Idle.start()
		$TakedDamage/Twinkle.start()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		position = Vector2()
		visible = false


func collect_item() -> void:
	$CollectedItem.play()


func _on_Twinkle_timeout():
	if $AnimatedSprite.modulate == Color("90ffffff"):
		$AnimatedSprite.modulate = Color("ffffffff")
	else:
		$AnimatedSprite.modulate = Color("90ffffff")


func _on_Idle_timeout():
	$TakedDamage/Twinkle.stop()
	is_weak = false
	$AnimatedSprite.modulate = Color("ffffffff")
