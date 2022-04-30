extends StaticBody2D
class_name Chest

var stage: Node2D


func _on_AnimatedSprite_animation_finished():
	#if randi()%9 in [0,1,2,3,4,5,6,7,8,9]: [only for tests!]
	if randi()%9 in [2,5,7]:
		_create_item()
	queue_free()


func _create_item() -> void:
	var item: Item = preload("res://scenes/world/item.tscn").instance()
	item.position = position
	stage.get_node("Items").add_child(item)


func destroy() -> void:
	$AnimatedSprite.play("exploding")
