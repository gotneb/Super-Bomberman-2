extends Node2D
class_name Explosion

var bomb
var _createExplosion := false

var direction = {
	"right": {
		"created": [],
		"detected": [],
		"distance": -1,
		"body": [],
	},
	"left": {
		"created": [],
		"detected": [],
		"distance": -1,
		"body": [],
	},
	"up": {
		"created": [],
		"detected": [],
		"distance": -1,
		"body": [],
	},
	"down": {
		"created": [],
		"detected": [],
		"distance": -1,
		"body": [],
	},
}

var power: int

var arms = {
	"left": [],
	"up": [],
	"right": [],
	"down": [],
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
	$EnableStubs.start()
	var explosions = [$Stubs/Left, $Stubs/Up, $Stubs/Right, $Stubs/Down, $Arms/HorizontalLeft, $Arms/HorizontalRight, $Arms/VerticalUp, $Arms/VerticalDown]
	for s in explosions:
		s.position = Vector2.ZERO


func _start_animations() -> void:
	var nodes = [$Stubs/Up, $Stubs/Down, $Stubs/Left, $Stubs/Right, $Arms/VerticalUp, $Arms/VerticalDown, $Arms/HorizontalLeft, $Arms/HorizontalRight, $Center]
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
			"up": [$Stubs/Up, $Arms/VerticalUp],
			"left": [$Stubs/Left, $Arms/HorizontalLeft],
			"right": [$Stubs/Right, $Arms/HorizontalRight],
			"down": [$Stubs/Down, $Arms/VerticalDown]
		}
		for i in range(1, power + 1):
			for t in ["left", "right", "up", "down"]:
				# Creates stubs' explosion
				if i == power:
					elem[t][0].position = $Center.position + i * _dir[t]
					direction[t]["created"].append(elem[t][0])
				# Creates arm's explosion
				else:
					arms[t].append(_create_node(elem[t][1], i * + _dir[t]))
					$".".add_child(arms[t][i-1])
					direction[t]["created"].append(arms[t][i-1])


func _on_Timer_timeout():
	for t in ["left", "right", "up", "down"]:
		setup(t)

	visible = true


func setup(d: String) -> void:
	# None black hasn't been captured
	if direction[d]["detected"].size() == 0:
		for i in direction[d]["created"]:
			i.visible = true
		for j in direction[d]["body"]:
			j.take_damage()
	# Some block has been captured
	else:
		for i in range(0, direction[d]["distance"] - 1):
			direction[d]["created"][i].visible = true
		direction[d]["detected"][0].destroy()
		for j in direction[d]["body"]:
			var dist = 0
			if d in ["left", "right"]:
				dist = abs($Center.global_position.x - j.global_position.x) / 16
			else:
				dist = round(abs($Center.global_position.y - j.global_position.y)) / 16
			if dist < direction[d]["distance"]:
				j.take_damage()


# ============= TAKE DAMAGE WHEN SOMETHING ENTER ===============
func take_damage(body, d: String) -> void:
	if body.is_in_group("bomb"):
		body.force_explode()
	elif body.is_in_group("blocks") or body is Item:
		direction[d]["detected"].append(body)
		var measure := 0
		if d in ["left", "right"]:
			measure = abs(body.position.x - $Center.global_position.x) / 16
		else:
			measure = round(abs(body.position.y - $Center.global_position.y + 1) / 16)
		# -1 means first time, because the distance cannot be negative
		if direction[d]["distance"] == -1 or measure < direction[d]["distance"]:
			direction[d]["distance"] = measure
	if body.is_in_group("player") or body.is_in_group("enemies"):
		direction[d]["body"].append(body)


func destroy_item(area, d) -> void:
	if area is Item:
		take_damage(area, d)


func _on_Center_body_entered(body):
	#take_damage(body)
	pass


func _on_Up_body_entered(body):
	take_damage(body, "up")


func _on_Down_body_entered(body):
	take_damage(body, "down")


func _on_VerticalUp_body_entered(body):
	take_damage(body, "up")


func _on_VerticalDown_body_entered(body):
	take_damage(body, "down")


func _on_Right_body_entered(body):
	take_damage(body, "right")


func _on_Left_body_entered(body):
	take_damage(body, "left")

func _on_HorizontalLeft_body_entered(body):
	take_damage(body, "left")


func _on_HorizontalRight_body_entered(body):
	take_damage(body, "right")
# =======================================================

# ================= DESTROY ITEM =========================
func _on_VerticalUp_area_entered(area):
	destroy_item(area, "up")


func _on_VerticalDown_area_entered(area):
	destroy_item(area, "down")


func _on_HorizontalLeft_area_entered(area):
	destroy_item(area, "left")


func _on_HorizontalRight_area_entered(area):
	destroy_item(area, "right")


func _on_Left_area_entered(area):
	destroy_item(area, "left")


func _on_Right_area_entered(area):
	destroy_item(area, "right")


func _on_Down_area_entered(area):
	destroy_item(area, "down")


func _on_Up_area_entered(area):
	destroy_item(area, "up")


# =======================================
# By default, all stubs are invisble and disabled colision
func _enable_stubs() -> void:
	var stubs =  [$Stubs/Up, $Stubs/Down, $Stubs/Left, $Stubs/Right]
	$Stubs.visible = true
	for i in stubs:
		i.get_node("CollisionShape2D").set_deferred("disabled", false)


# Bomb created explosion in your tree, so when bomb is cleaned the explosion too
func _on_AnimatedSprite_animation_finished():
	bomb.queue_free()


# Abling stubs after enabling arms takes a short time, so when exploded,
# The stubs they arent detecting blocks  
func _on_EnableStubs_timeout():
	_enable_stubs()
