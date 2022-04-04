extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	# It detects nodes grouped or the center
	if area.get_parent().get_parent() is Explosion or area.get_parent():
		print("Explosion")
		$AnimatedSprite.play("exploding")


func _on_AnimatedSprite_animation_finished():
	queue_free()
