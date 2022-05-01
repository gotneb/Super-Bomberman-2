extends StaticBody2D
class_name Magnet

var _shortest_dist = -1
var _actual_direction = 1

var is_there_bomb:= false
var bomb

var _texture = {
	0: preload("res://assets/blocks/magnet/left.png"),
	1: preload("res://assets/blocks/magnet/up.png"),
	2: preload("res://assets/blocks/magnet/right.png"),
	3: preload("res://assets/blocks/magnet/down.png"),
}


func change_direction() -> void:
	_actual_direction += 1
	if _actual_direction >= 3:
		_actual_direction = 0
	$Sprite.texture = _texture[_actual_direction]


# TODO: Fix explosion's method
# dummy function, because in explosion this method is called
func destroy() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


# TODO: Function only works for some bomb above magnet
func _on_Area2D_area_entered(area):
	if area.get_parent().has_method("atract_bomb") and _actual_direction == 1:
		var dist = global_position.distance_to(area.global_position)
		if _shortest_dist == -1 or dist < _shortest_dist:
			_shortest_dist = dist
			is_there_bomb = true
			bomb = area

		# Atracts bomb from down
		if is_there_bomb:
			if global_position.y > bomb.global_position.y and global_position.x == bomb.global_position.x:
				bomb.get_parent().atract_bomb(self, Vector2.DOWN)


func bomb_exploded() -> void:
	_shortest_dist = -1
	is_there_bomb = false
