extends StaticBody2D


func _ready():
	pass


func _on_Area2D_area_entered(area):
	pass
	#if area.is_in_group("vertical_arm"):
		#_remove_elements(["up", "down"], area)
	#if area.is_in_group("horizontal_arm"):
		#_remove_elements(["left", "right"], area)


func _remove_elements(keys: Array, area: Area2D):
	var parent: Node2D = area.get_parent()
	for key in keys:
		var arms = parent.arms[key]
		if arms.find(area) != -1:
			for i in range(arms.find(area), arms.size()):
				arms[i].queue_free()
			parent.get_node("Stubs").get_node(key.capitalize()).queue_free()
