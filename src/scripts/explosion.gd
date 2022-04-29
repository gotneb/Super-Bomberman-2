extends Node2D
class_name Explosion

var bomb
var _createExplosion := false

var right_created = []
var right_horizontal_detected = []
var distance := -1
var power: int

var arms = {
	"left": [],
	"up": [],
	"right": [],
	"down": [],
}

var detected = {
	"left": [[], []],
	"right": [[], []],
}

var _dir = {
	"left": Vector2.LEFT * 16,
	"up": Vector2.UP * 16,
	"right": Vector2.RIGHT * 16,
	"down": Vector2.DOWN * 16,
}

func _ready():
	visible = false
	$Explosion.play(0.7)
	_createExplosion = true
	$Timer.start()
	var explosions = [$Stubs/Left, $Stubs/Up, $Stubs/Right, $Stubs/Down, $Arms/Horizontal, $Arms/Vertical]
	for s in explosions:
		s.position = Vector2.ZERO


func _start_animations() -> void:
	var nodes = [$Stubs/Up, $Stubs/Down, $Stubs/Left, $Stubs/Right, $Arms/Vertical, $Arms/Horizontal, $Center]
	for i in nodes:
		i.get_node("AnimatedSprite").play("default")


func _create_node(arm: Node2D, pos: Vector2) -> Node2D:
	var node = arm.duplicate()
	node.position = pos
	node.visible = false
	node.get_node("CollisionShape2D").set_deferred("disabled", false)
	return node


func _process(delta: float) -> void:
	if _createExplosion:
		_createExplosion = false
		_start_animations()
		var elem = {
			"up": [$Stubs/Up, $Arms/Vertical],
			"left": [$Stubs/Left, $Arms/Horizontal],
			"right": [$Stubs/Right, $Arms/Horizontal],
			"down": [$Stubs/Down, $Arms/Vertical]
		}
		for i in range(1, power + 1):
			# Creates stubs' explosion
			var t := "right"
			if i == power:
				elem[t][0].position = $Center.position + i * _dir[t]
				right_created.append(elem[t][0])
				print("created")
			else:
				arms[t].append(_create_node(elem[t][1], i * + _dir[t]))
				$".".add_child(arms[t][i-1])
				right_created.append(arms[t][i-1])

		_enable_stubs()


func _on_Timer_timeout():
	if right_horizontal_detected.size() == 0:
		for i in right_created:
			i.visible = true
	else:
	# Some block has been captured
		right_horizontal_detected.append(right_horizontal_detected[0])
		right_horizontal_detected.remove(0)
		for i in range(0, distance - 1):
			right_created[i].visible = true
		right_horizontal_detected[0].destroy()

	print("right catched: ", right_horizontal_detected.size())
	visible = true


# By default, all stubs are invisble and disabled colision
func _enable_stubs() -> void:
	var stubs =  [$Stubs/Up, $Stubs/Down, $Stubs/Left, $Stubs/Right]
	$Stubs.visible = true
	for i in stubs:
		i.get_node("CollisionShape2D").set_deferred("disabled", false)


# Bomb created explosion in your tree, so when bomb is cleaned the explosion too
func _on_AnimatedSprite_animation_finished():
	bomb.queue_free()


# ============= TAKE DAMAGE WHEN SOMETHING ENTER ===============
func take_damage(body) -> void:
	if body.is_in_group("blocks"):
		right_horizontal_detected.append(body)
		var measure = abs(body.position.x - $Center.global_position.x) / 16
		if distance == -1 or measure < distance:
			distance = measure
	elif body.is_in_group("player"):
		body.take_damage()
	elif body.is_in_group("enemies"):
		body.take_damage()


func _on_Center_body_entered(body):
	take_damage(body)


func _on_Up_body_entered(body):
	take_damage(body)


func _on_Down_body_entered(body):
	take_damage(body)


func _on_Right_body_entered(body):
	take_damage(body)


func _on_Left_body_entered(body):
	take_damage(body)
# =======================================================

# ================= DESTROY ITEM =========================
func destroy_item(area) -> void:
	if area is Item:
		area.destroy()


func _on_Left_area_entered(area):
	destroy_item(area)


func _on_Right_area_entered(area):
	destroy_item(area)


func _on_Down_area_entered(area):
	destroy_item(area)


func _on_Up_area_entered(area):
	destroy_item(area)


func _on_Horizontal_body_entered(body):
	take_damage(body)
# =======================================
