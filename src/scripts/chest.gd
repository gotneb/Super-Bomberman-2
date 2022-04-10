extends StaticBody2D
class_name Chest

var stage: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_area_entered(area):
	# It detects nodes grouped or the center
	if area.get_parent().get_parent() is Explosion or area.get_parent() is Explosion:
		$AnimatedSprite.play("exploding")


func _on_AnimatedSprite_animation_finished():
	if randi()%9 == 5 or randi()%9 == 6:
		_create_item()
	queue_free()


func _create_item() -> void:
	var item: Item = preload("res://scenes/world/item.tscn").instance()
	item.position = position
	stage.get_node("Items").add_child(item)
