extends Node2D
class_name Explosion

var bomb
var _createExplosion := false

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

var power := 3

func _ready():
	visible = false
	$Timer.start()
	$Arms/Horizontal.position = Vector2.ZERO
	$Arms/Vertical.position = Vector2.ZERO


func _process(delta: float) -> void:
	if _createExplosion:
		_enable_stubs()
		_start_animations()
		for i in range(1, power + 1):
			var elem = {"up": [$Stubs/Up, $Arms/Vertical], "left": [$Stubs/Left, $Arms/Horizontal], "right": [$Stubs/Right, $Arms/Horizontal], "down": [$Stubs/Down, $Arms/Vertical]}
			# Create stubs' explosion
			if i == power:
				for key in elem:
					elem[key][0].position = $Center.position + i * _dir[key]
			# Create arms' explosion
			else:
				for key in elem:
					arms[key].append(_create_node(elem[key][1], i * + _dir[key]))
					$".".add_child(arms[key][i -1])
		_createExplosion = false


func _on_Timer_timeout():
	$Explosion.play(0.7)
	_createExplosion = true
	visible = true


func _create_node(arm: Node2D, pos: Vector2) -> Node2D:
	var node = arm.duplicate()
	node.position = pos
	node.visible = true
	node.get_node("CollisionShape2D").set_deferred("disabled", false)
	return node


func _start_animations() -> void:
	var nodes = [$Stubs/Up, $Stubs/Down, $Stubs/Left, $Stubs/Right, $Arms/Vertical, $Arms/Horizontal, $Center]
	for i in nodes:
		i.get_node("AnimatedSprite").play("default")


# By default, all stubs are invisble and disabled colision
func _enable_stubs() -> void:
	var stubs =  [$Stubs/Up, $Stubs/Down, $Stubs/Left, $Stubs/Right]
	for i in stubs:
		i.visible = true
		i.get_node("CollisionShape2D").set_deferred("disabled", false)


# Bomb created explosion in your tree, so when bomb is cleaned the explosion too
func _on_AnimatedSprite_animation_finished():
	bomb.queue_free()
