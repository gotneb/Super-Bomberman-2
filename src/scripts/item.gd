extends Area2D
class_name Item


func _ready():
	var anim = ["fire", "life", "speed", "bomb"]
	$AnimatedSprite.play(anim[randi()%4])


func _on_Item_body_entered(body):
	if body is Player:
		match $AnimatedSprite.animation:
			"bomb":
				body.bombs += 1
			"fire":
				body.fire += 1
			"life":
				body.lifes += 1
			"speed":
				body.speed += 10
		body.collect_item()
		queue_free()
