extends KinematicBody2D
class_name Bomb

var _hasExploded := false
var power: int
var player

var _has_magnet_entered := false
onready var _speed := 60
var _direction := Vector2()

var _magnet: Magnet

func _ready():
	$AnimatedSprite.play("default")
	$Timer.start()


func _process(delta: float) -> void:
	if _magnet != null and position.y > _magnet.global_position.y - 9:
		_has_magnet_entered = false
	if _has_magnet_entered:
		move_and_slide(_direction * _speed * delta * 100)


func _start_explosion() -> void:
	_hasExploded = true
	_direction = Vector2.ZERO # Stop moving
	$AnimatedSprite.visible = false
	$Colision.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	if _magnet != null:
		_magnet.bomb_exploded()
	_create_explosion()


func _on_Timer_timeout():
	_start_explosion()


func _create_explosion() -> void:
	var explosion: Explosion = preload("res://scenes/world/bombs/explosion.tscn").instance()
	explosion.position = Vector2(0, -7)
	explosion.bomb = self
	explosion.power = power
	$Explosion.add_child(explosion)
	player.bombs += 1


func _on_body_exited(body):
	if not _hasExploded and body.is_in_group("player"):
		$Colision.set_deferred("disabled", false)
		body.is_inside_bomb = false


func force_explode() -> void:
	if not _hasExploded:
		$Timer.stop()
		call_deferred("_start_explosion")


func atract_bomb(magnet: Magnet, d: Vector2) -> void:
	if not _has_magnet_entered:
		print("Magnet detected")
		_has_magnet_entered = true
		_direction = d
		_magnet = magnet
