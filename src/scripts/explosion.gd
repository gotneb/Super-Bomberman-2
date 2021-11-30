extends Node2D
class_name Explosion

var bomb
var _createExplosion := false

var _dir = {
	"left": Vector2.LEFT * 16,
	"up": Vector2.UP * 16,
	"right": Vector2.RIGHT * 16,
	"down": Vector2.DOWN * 16,
}

var power := 3

func _ready():
	$Timer.start()
	$Arms/Horizontal.position = Vector2.ZERO
	$Arms/Vertical.position = Vector2.ZERO


func _process(delta: float) -> void:
	if _createExplosion:
		_enable_stubs()
		_start_animations()
		for i in range(1, power + 1):
			if i == power:
				$Stubs/Up.position = $Center.position + i * _dir["up"]
				$Stubs/Down.position = $Center.position + i * _dir["down"]
				$Stubs/Left.position = $Center.position + i * _dir["left"]
				$Stubs/Right.position = $Center.position + i * _dir["right"]
			else:
				$".".add_child(_create_node($Arms/Vertical, i * + _dir["up"]))
				$".".add_child(_create_node($Arms/Vertical, i * + _dir["down"]))
				$".".add_child(_create_node($Arms/Horizontal, i * + _dir["right"]))
				$".".add_child(_create_node($Arms/Horizontal, i * + _dir["left"]))
		_createExplosion = false


func _on_Timer_timeout():
	_createExplosion = true


func _create_node(arm: Node2D, pos: Vector2) -> Node2D:
	var node = arm.duplicate()
	node.position = pos
	node.visible = true
	node.get_node("CollisionShape2D").set_deferred("disabled", false)
	return node


func _start_animations() -> void:
	var nodes = [$Stubs/Up, $Stubs/Down, $Stubs/Left, $Stubs/Right, $Arms/Vertical, $Arms/Horizontal]
	for i in nodes:
		i.get_node("AnimatedSprite").play("default")
	$Center/AnimatedSprite.play("default")


# By default, all stubs are invisble and disabled colision
func _enable_stubs() -> void:
	var stubs =  [$Stubs/Up, $Stubs/Down, $Stubs/Left, $Stubs/Right]
	for i in stubs:
		i.visible = true
		i.get_node("CollisionShape2D").set_deferred("disabled", false)


# Bomb created explosion in your tree, so when bomb is cleaned the explosion too
func _on_AnimatedSprite_animation_finished():
	bomb.queue_free()
