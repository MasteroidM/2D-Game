extends Node2D


func create_grass_effect():
	var grass = load("res://Effects/effect.tscn")
	var grasseff = grass.instance()
	var main = get_tree().current_scene
	main.add_child(grasseff)
	grasseff.global_position = global_position



func _on_hurt_area_entered(area):
	create_grass_effect()
	queue_free()
