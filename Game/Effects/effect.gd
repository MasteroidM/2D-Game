extends Node2D


onready var leaf = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	leaf.play("leaves"	)



func _on_AnimatedSprite_animation_finished():
	queue_free()
