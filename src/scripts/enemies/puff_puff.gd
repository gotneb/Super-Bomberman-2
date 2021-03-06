extends KinematicBody2D
class_name PuffPuff

#var type := "enemy"

var direction: Vector2
var speed := 16
var is_alive := true
var actual_position: Vector2

var velocity := Vector2(1,0)

var is_free = {
	Vector2.LEFT: true,
	Vector2.UP: true,
	Vector2.RIGHT: true,
	Vector2.DOWN: true,
}


# Called when the node enters the scene tree for the first time.
func _ready():
	direction = sort_direction()
	$ChangeDirection.start()
	randomize()
	actual_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_alive: 
		return

	if floor(position.x) != floor(actual_position.x) or floor(position.y) != floor(actual_position.y):
		actual_position = position
		$ChangeDirection.start()
	update_direction(delta)
	
	velocity = move_and_slide(velocity)


func update_direction(delta: float) -> void:
	match direction:
		Vector2.LEFT:
			$AnimatedSprite.play("left")
			velocity = Vector2.LEFT * speed * delta * 100
			$AnimatedSprite.flip_h = false
		Vector2.UP:
			$AnimatedSprite.play("top")
			velocity = Vector2.UP * speed * delta * 100
		Vector2.RIGHT:
			$AnimatedSprite.play("right")
			velocity = Vector2.RIGHT * speed * delta * 100
			$AnimatedSprite.flip_h = true
		Vector2.DOWN:
			$AnimatedSprite.play("down")
			velocity = Vector2.DOWN * speed * delta * 100


func sort_direction() -> Vector2:
	var list_directions = [Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]
	var newDir = list_directions[randi()%4]
	
	while not is_free[newDir]:
		newDir = list_directions[randi()%4]

	return newDir


func _on_Timer_timeout():
	direction = sort_direction()


# ==================== SIGNALS FROM DETECTORS ===============
func _on_Up_area_entered(area):
		_update_free_directions(Vector2.UP, false, $Detectors/Up.get_overlapping_areas().size())


func _on_Up_area_exited(area):
	_update_free_directions(Vector2.UP, true, $Detectors/Up.get_overlapping_areas().size())


func _on_Right_area_entered(area):
	_update_free_directions(Vector2.RIGHT, false, $Detectors/Right.get_overlapping_areas().size())


func _on_Right_area_exited(area):
	_update_free_directions(Vector2.RIGHT, true, $Detectors/Right.get_overlapping_areas().size())


func _on_Left_area_entered(area):
	_update_free_directions(Vector2.LEFT, false, $Detectors/Left.get_overlapping_areas().size())


func _on_Left_area_exited(area):
	_update_free_directions(Vector2.LEFT, true, $Detectors/Left.get_overlapping_areas().size())


func _on_Down_area_entered(area):
	_update_free_directions(Vector2.DOWN, false, $Detectors/Down.get_overlapping_areas().size())


func _on_Down_area_exited(area):
	_update_free_directions(Vector2.DOWN, true, $Detectors/Down.get_overlapping_areas().size())
# =====================================================================


func _update_free_directions(vector: Vector2, value: bool, over_areas: int) -> void:
	if over_areas < 1:
		is_free[vector] = value
	else:
		is_free[vector] = false


# ==================== DEATH =============================
func take_damage() -> void:
	is_alive = false
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$Die.start()
	$AnimatedSprite.play("death")


func _on_Die_timeout():
	queue_free()


# ================= KILL PLAYER =======================
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage()
