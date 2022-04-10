extends Node2D


func _ready():
	$Player.stage = self
	
	for c in $Chests.get_children():
		c.stage = self
