extends Area2D
class_name Item


func _ready():
	var anim = ["fire", "life", "speed", "bomb"]
	$AnimatedSprite.play(anim[randi()%4])


func _on_Item_body_entered(body):
	if body.is_in_group("player"):
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


func destroy() -> void:
	$CollisionShape2D.set_deferred("disabled", false)
	$AnimatedSprite.play("destroying")


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "destroying":
		queue_free()
